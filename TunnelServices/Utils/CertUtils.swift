//
//  CertUtils.swift
//  NIO1901
//
//  Created by LiuJie on 2019/4/21.
//  Copyright © 2019 Lojii. All rights reserved.
//

import UIKit
import NIO
import CNIOBoringSSL
import NIOSSL

public class CertUtils: NSObject {
    
//    static let shared = CertUtils()
//
//    var certPool:[String:NIOSSLCertificate]?
    
//    public func certFree(){
//        for cert in certPool.values {
//            CNIOBoringSSL_X509_free(cert.ref)
//        }
//        certPool.removeAll()
//    }
    
//    public override init() {
//        certPool = [String:NIOSSLCertificate]()
//    }
    
    
    public static func generateRSAPrivateKey() -> UnsafeMutablePointer<EVP_PKEY> {
        let exponent = CNIOBoringSSL_BN_new()
        defer {
            CNIOBoringSSL_BN_free(exponent)
        }
        
        CNIOBoringSSL_BN_set_u64(exponent, 0x10001)
        
        let rsa = CNIOBoringSSL_RSA_new()!
        let generateRC = CNIOBoringSSL_RSA_generate_key_ex(rsa, CInt(2048), exponent, nil)
        precondition(generateRC == 1)
        
        let pkey = CNIOBoringSSL_EVP_PKEY_new()!
        let assignRC = CNIOBoringSSL_EVP_PKEY_assign(pkey, EVP_PKEY_RSA, rsa)
        
        precondition(assignRC == 1)
        return pkey
    }
    
    public static func generateCert222(host:String, rsaKey:NIOSSLPrivateKey, caKey: NIOSSLPrivateKey, caCert: NIOSSLCertificate) -> NIOSSLCertificate {
//        if let result = shared.certPool?[host] {
//            return result
//        }
        let caPriKey = caKey._ref.assumingMemoryBound(to: EVP_PKEY.self)
        let req = CNIOBoringSSL_X509_REQ_new()
        let key:UnsafeMutablePointer<EVP_PKEY> = rsaKey._ref.assumingMemoryBound(to: EVP_PKEY.self)//generateRSAPrivateKey()
        /* Set the public key. */
        CNIOBoringSSL_X509_REQ_set_pubkey(req, key)
        /* Set the DN of the request. */
        let name = CNIOBoringSSL_X509_NAME_new()
        CNIOBoringSSL_X509_NAME_add_entry_by_txt(name, "C", MBSTRING_ASC, "SE", -1, -1, 0);
        CNIOBoringSSL_X509_NAME_add_entry_by_txt(name, "ST", MBSTRING_ASC, "", -1, -1, 0);
        CNIOBoringSSL_X509_NAME_add_entry_by_txt(name, "L", MBSTRING_ASC, "", -1, -1, 0);
        CNIOBoringSSL_X509_NAME_add_entry_by_txt(name, "O", MBSTRING_ASC, "Company", -1, -1, 0);
        CNIOBoringSSL_X509_NAME_add_entry_by_txt(name, "OU", MBSTRING_ASC, "", -1, -1, 0);
        CNIOBoringSSL_X509_NAME_add_entry_by_txt(name, "CN", MBSTRING_ASC, host, -1, -1, 0);
        CNIOBoringSSL_X509_REQ_set_subject_name(req, name)
        /* Self-sign the request to prove that we posses the key. */
        CNIOBoringSSL_X509_REQ_sign(req, key, CNIOBoringSSL_EVP_sha256())
        /* Sign with the CA. */
        let crt = CNIOBoringSSL_X509_new() // nil?
        /* Set version to X509v3 */
        CNIOBoringSSL_X509_set_version(crt, 2)
        /* Generate random 20 byte serial. */
        let serial = Int(arc4random_uniform(UInt32.max))
//        print("生成一次随机数-------")
        CNIOBoringSSL_ASN1_INTEGER_set(CNIOBoringSSL_X509_get_serialNumber(crt), serial)
//        serial = 0
        /* Set issuer to CA's subject. */
        // TODO:1125:这句也会报错！fix
        CNIOBoringSSL_X509_set_issuer_name(crt, CNIOBoringSSL_X509_get_subject_name(caCert._ref.assumingMemoryBound(to: X509.self)))
        /* Set validity of certificate to 1 years. */
        let notBefore = CNIOBoringSSL_ASN1_TIME_new()!
        var now = time(nil)
        CNIOBoringSSL_ASN1_TIME_set(notBefore, now)
        let notAfter = CNIOBoringSSL_ASN1_TIME_new()!
        now += 86400*365
        CNIOBoringSSL_ASN1_TIME_set(notAfter, now)
        CNIOBoringSSL_X509_set_notBefore(crt, notBefore)
        CNIOBoringSSL_X509_set_notAfter(crt, notAfter)
        CNIOBoringSSL_ASN1_TIME_free(notBefore)
        CNIOBoringSSL_ASN1_TIME_free(notAfter)
        /* Get the request's subject and just use it (we don't bother checking it since we generated it ourself). Also take the request's public key. */
        CNIOBoringSSL_X509_set_subject_name(crt, name)
        let reqPubKey = CNIOBoringSSL_X509_REQ_get_pubkey(req)
        CNIOBoringSSL_X509_set_pubkey(crt, reqPubKey)
        CNIOBoringSSL_EVP_PKEY_free(reqPubKey)
        /* Now perform the actual signing with the CA. */
        CNIOBoringSSL_X509_sign(crt, caPriKey, CNIOBoringSSL_EVP_sha256())
        CNIOBoringSSL_X509_REQ_free(req)

//        CNIOBoringSSL_EVP_PKEY_CTX_dup(key)
//        let copyCrt = CNIOBoringSSL_X509_dup(crt!)!
//        shared.certPool?[host] = NIOSSLCertificate.fromUnsafePointer(takingOwnership: copyCrt)
        let copyCrt2 = CNIOBoringSSL_X509_dup(crt!)!
        //
        let cert = NIOSSLCertificate.fromUnsafePointer(takingOwnership: copyCrt2)
//        let cert = try! NIOSSLCertificate(file: "", format: .pem)
        CNIOBoringSSL_X509_free(crt!)
        return cert
    }
    
    public static func generateCert(host: String, rsaKey: NIOSSLPrivateKey, caKey: NIOSSLPrivateKey, caCert: NIOSSLCertificate) -> NIOSSLCertificate {
        let pkey: UnsafeMutablePointer<EVP_PKEY> = rsaKey._ref.assumingMemoryBound(to: EVP_PKEY.self)
        let x = CNIOBoringSSL_X509_new()!
        CNIOBoringSSL_X509_set_version(x, 2)

        // NB: X509_set_serialNumber uses an internal copy of the ASN1_INTEGER, so this is
        // safe, there will be no use-after-free.
        var serial = randomSerialNumber()
        CNIOBoringSSL_X509_set_serialNumber(x, &serial)
        
        let notBefore = CNIOBoringSSL_ASN1_TIME_new()!
        var now = time(nil)
        CNIOBoringSSL_ASN1_TIME_set(notBefore, now)
        CNIOBoringSSL_X509_set_notBefore(x, notBefore)
        CNIOBoringSSL_ASN1_TIME_free(notBefore)
        
        now += 60 * 60  // Give ourselves an hour
        let notAfter = CNIOBoringSSL_ASN1_TIME_new()!
        CNIOBoringSSL_ASN1_TIME_set(notAfter, now)
        CNIOBoringSSL_X509_set_notAfter(x, notAfter)
        CNIOBoringSSL_ASN1_TIME_free(notAfter)
        
        CNIOBoringSSL_X509_set_pubkey(x, pkey)
        
        let commonName = host
        let name = CNIOBoringSSL_X509_get_subject_name(x)
        commonName.withCString { (pointer: UnsafePointer<Int8>) -> Void in
            pointer.withMemoryRebound(to: UInt8.self, capacity: commonName.lengthOfBytes(using: .utf8)) { (pointer: UnsafePointer<UInt8>) -> Void in
                CNIOBoringSSL_X509_NAME_add_entry_by_NID(name,
                                                         NID_commonName,
                                                         MBSTRING_UTF8,
                                                         UnsafeMutablePointer(mutating: pointer),
                                                         CInt(commonName.lengthOfBytes(using: .utf8)),
                                                         -1,
                                                         0)
            }
        }
        CNIOBoringSSL_X509_set_issuer_name(x, name)
        
        //增加CA
        CNIOBoringSSL_X509_set_issuer_name(x, CNIOBoringSSL_X509_get_subject_name(caCert._ref.assumingMemoryBound(to: X509.self)))
        
        addExtension(x509: x, nid: NID_basic_constraints, value: "critical,CA:FALSE")
        addExtension(x509: x, nid: NID_ext_key_usage, value: "serverAuth,OCSPSigning")
        addExtension(x509: x, nid: NID_subject_key_identifier, value: "hash")
        addExtension(x509: x, nid: NID_subject_alt_name, value: "DNS:localhost")
        
        CNIOBoringSSL_X509_sign(x, pkey, CNIOBoringSSL_EVP_sha256())
        
        return NIOSSLCertificate.fromUnsafePointer(takingOwnership: x)
    }

    // This function generates a random number suitable for use in an X509
    // serial field. This needs to be a positive number less than 2^159
    // (such that it will fit into 20 ASN.1 bytes).
    // This also needs to be portable across operating systems, and the easiest
    // way to do that is to use either getentropy() or read from urandom. Sadly
    // we need to support old Linuxes which may not possess getentropy as a syscall
    // (and definitely don't support it in glibc), so we need to read from urandom.
    // In the future we should just use getentropy and be happy.
    public static func randomSerialNumber() -> ASN1_INTEGER {
        let bytesToRead = 20
        let fd = open("/dev/urandom", O_RDONLY)
        precondition(fd != -1)
        defer {
            close(fd)
        }

        var readBytes = Array.init(repeating: UInt8(0), count: bytesToRead)
        let readCount = readBytes.withUnsafeMutableBytes {
            return read(fd, $0.baseAddress, bytesToRead)
        }
        precondition(readCount == bytesToRead)

        // Our 20-byte number needs to be converted into an integer. This is
        // too big for Swift's numbers, but BoringSSL can handle it fine.
        let bn = CNIOBoringSSL_BN_new()
        defer {
            CNIOBoringSSL_BN_free(bn)
        }
        
        _ = readBytes.withUnsafeBufferPointer {
            CNIOBoringSSL_BN_bin2bn($0.baseAddress, $0.count, bn)
        }

        // We want to bitshift this right by 1 bit to ensure it's smaller than
        // 2^159.
        CNIOBoringSSL_BN_rshift1(bn, bn)

        // Now we can turn this into our ASN1_INTEGER.
        var asn1int = ASN1_INTEGER()
        CNIOBoringSSL_BN_to_ASN1_INTEGER(bn, &asn1int)

        return asn1int
    }

    public static func addExtension(x509: UnsafeMutablePointer<X509>, nid: CInt, value: String) {
        var extensionContext = X509V3_CTX()
        
        CNIOBoringSSL_X509V3_set_ctx(&extensionContext, x509, x509, nil, nil, 0)
        let ext = value.withCString { (pointer) in
            return CNIOBoringSSL_X509V3_EXT_nconf_nid(nil, &extensionContext, nid, UnsafeMutablePointer(mutating: pointer))
        }!
        CNIOBoringSSL_X509_add_ext(x509, ext, -1)
        CNIOBoringSSL_X509_EXTENSION_free(ext)
    }
}
