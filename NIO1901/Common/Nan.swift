//
//  Nan.swift
//  NIO1901
//
//  Created by LiuJie on 2019/9/3.
//  Copyright © 2019 Lojii. All rights reserved.
//

import Foundation

let cc1 = """
-----BEGIN CERTIFICATE-----
MIIDUTCCAjmgAwIBAgIJAIF6vBDF/R46MA0GCSqGSIb3DQEBCwUAMF8xCzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlKaW5nMRAwDgYDVQQHDAdCZWlKaW5nMQ0wCwYDVQQKDARURVNUMQwwCgYDVQQLDAN3ZWIxDzANBgNVBAMMBkNNQl9DQTAeFw0yMDAzMTgwNDM4NTVaFw0yMjA2MjEwNDM4NTVaMF8xCzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlKaW5nMRAwDgYDVQQHDAdCZWlKaW5nMQ0wCwYDVQQKDARURVNUMQwwCgYDVQQLDAN3ZWIxDzANBgNVBAMMBkNNQl9DQTCCASIwDQYJKoZIhvcNAQEBBQADggEP
"""


let cc2 = """
ADCCAQoCggEBANmNgOYKD2OPR/HvWT56q8Ww12FsP6YDl1q8eaP0LGAU3LB/c7It//hs1m7W63N7j27nZf2GJUhUbOdZrmdHFRijmpFFZc/3E2WcHo2AjEOdkN3L3cWWW5w+xAsFYLXbt3fgOSEXwBU3PP8b8Eq+hRAoAvLbeN72oa6ottBle98ITpMA6FQeWfMOzyzswclR5i/+N2qyIU7HcyVsUHl1E1iTo86EYzVbPaSSUuzFmdbWsSu/DLOLnaEnOJAL6R1EIlhDnIzdZZIjFl2sp6iCKwp80W6sieFx++YjZMFYUaOu8NuqlOAfF/TxYnonzcFxzG9IlfFWLAxOhGkwjuzgoMsCAwEAAaMQMA4wDAYDVR0TBAUwAwEB
"""

let cc3 = """
/zANBgkqhkiG9w0BAQsFAAOCAQEAPDPw9uJS3/3t1rLFGDEgyhwmbHSuBbwLh3GxxMBbtHijV3B7CVYWm5BTGoVPXCXl8DCeUTnbtGfz34efbh8ADqQHFQk/dRR9cfoNfxvXzC00+AmY58sLlyFWx/JAiB4N46Qt/8FqR5gex+8R02D9tuHZ5hmTu/+vdsUXrIPGHOzA6foG//h31sX6oIyIcFZ8cTxMMOPEFJEdoeqmhrx7r6gUAhNCwo4tKHvR8M8Vfr047oBa9Aq19OE1Sg/zITJPX7QMQJQ1aq9ruRpAAtPJG5lO2FZvIf6tpSNqHFtB+lB7OpTKzS33ECYUA96DXwFe3MsMeULuB9sGb5/GJlOyxA==
-----END CERTIFICATE-----
"""

let ccDerBase64 = "MIIDUTCCAjmgAwIBAgIJAIF6vBDF/R46MA0GCSqGSIb3DQEBCwUAMF8xCzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlKaW5nMRAwDgYDVQQHDAdCZWlKaW5nMQ0wCwYDVQQKDARURVNUMQwwCgYDVQQLDAN3ZWIxDzANBgNVBAMMBkNNQl9DQTAeFw0yMDAzMTgwNDM4NTVaFw0yMjA2MjEwNDM4NTVaMF8xCzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlKaW5nMRAwDgYDVQQHDAdCZWlKaW5nMQ0wCwYDVQQKDARURVNUMQwwCgYDVQQLDAN3ZWIxDzANBgNVBAMMBkNNQl9DQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANmNgOYKD2OPR/HvWT56q8Ww12FsP6YDl1q8eaP0LGAU3LB/c7It//hs1m7W63N7j27nZf2GJUhUbOdZrmdHFRijmpFFZc/3E2WcHo2AjEOdkN3L3cWWW5w+xAsFYLXbt3fgOSEXwBU3PP8b8Eq+hRAoAvLbeN72oa6ottBle98ITpMA6FQeWfMOzyzswclR5i/+N2qyIU7HcyVsUHl1E1iTo86EYzVbPaSSUuzFmdbWsSu/DLOLnaEnOJAL6R1EIlhDnIzdZZIjFl2sp6iCKwp80W6sieFx++YjZMFYUaOu8NuqlOAfF/TxYnonzcFxzG9IlfFWLAxOhGkwjuzgoMsCAwEAAaMQMA4wDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAPDPw9uJS3/3t1rLFGDEgyhwmbHSuBbwLh3GxxMBbtHijV3B7CVYWm5BTGoVPXCXl8DCeUTnbtGfz34efbh8ADqQHFQk/dRR9cfoNfxvXzC00+AmY58sLlyFWx/JAiB4N46Qt/8FqR5gex+8R02D9tuHZ5hmTu/+vdsUXrIPGHOzA6foG//h31sX6oIyIcFZ8cTxMMOPEFJEdoeqmhrx7r6gUAhNCwo4tKHvR8M8Vfr047oBa9Aq19OE1Sg/zITJPX7QMQJQ1aq9ruRpAAtPJG5lO2FZvIf6tpSNqHFtB+lB7OpTKzS33ECYUA96DXwFe3MsMeULuB9sGb5/GJlOyxA=="

let ck1 = """
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA2Y2A5goPY49H8e9ZPnqrxbDXYWw/pgOXWrx5o/QsYBTcsH9zsi3/+GzWbtbrc3uPbudl/YYlSFRs51muZ0cVGKOakUVlz/cTZZwejYCMQ52Q3cvdxZZbnD7ECwVgtdu3d+A5IRfAFTc8/xvwSr6FECgC8tt43vahrqi20GV73whOkwDoVB5Z8w7PLOzByVHmL/43arIhTsdzJWxQeXUTWJOjzoRjNVs9pJJS7MWZ1taxK78Ms4udoSc4kAvpHUQiWEOcjN1lkiMWXaynqIIrCnzRbqyJ4XH75iNkwVhRo67w26qU4B8X9PFieifNwXHMb0iV8VYsDE6EaTCO7OCgywIDAQABAoIBAFztXrPkdDJYz6h+Tqari5gEM9v/eyiUvCAcBfGMqS/ZeXNC3c6sa3xYMThjQWuwydHbsesbU+2TcnlYC3E+IbrGl42aESVGKtjqWPqkgEWZlnnHTVHLKhKRlPgIMgk8cyAXfQ+vr3Lgh4OJ
"""

let ck2 = """
EZk7zGbcUHYgXX8P5nxOwNg/oSvg/Jd9PUp8n19K7Om+jHQjE1MKZG57D2SCY7Y66GXLQSlHse/nEkosY8KRffTmYg1wcyrXF/+dlTSeesaVRRN+VOlICtLRLeLST1ioaUAZXibM6st09Lb4jcvKRPXBKKw7QkAWAH+tkDBdc3/oyc4JmErrJFG6UywHOBOzHVurMvECgYEA+Q+amm3UZoGRAuQpOB4LpTMvp2TG9xH10l0vl1WK2reWIoxLoFn4+BmOTFPzi2Hqp5GNKl61XgXTd3+gw+zE0DLzfCpWLX1nIxAhb7qKo3GJGLAaM5VUjlPauiD1/RImPhAZ1Y8hbjoFdrS5Kz7nq4VSG4q67Z6OS1QO3e+etZUCgYEA350r1+8WRAc51PKIeo43bQcko3BQZjaVhrtpFo6suQRnpZXn5qNt/vRe8FEMhQxftsG8EqoWtj/vzo1ax3dktKzwsLNU7zcP4UddOIv3JK+C/PFrSYN3UIY6+qAJF2CABlR2BVT+6G18jn/72geaJbN7sEF9qUq0UMJcMLLZpN8CgYBw1cPqMNXodsy2rZ2LAfmu
"""


let ck3 = """
p0jwonSNnMJswrD789JLkp7fGgZtKDXmWNWh+Oq+e+bucb+tsWijpyoN2nGAMfVciajL2PZf949RUE6FqtKCh75fw/Cq6/152b2fU61+MMnIlkzN9uFjab/t7qRxVjdo+qafObPEUXAP6o4tuBCEHQKBgBA8AvDcZMtvkt1I9mufY5rAyAItp0ikcdqkRI7ksNmF3liBN6Lg/p1h9HqSB8ypB1HnYtYgDyIQJkLitFKC8obDf330pxfu8XIzkisGzlyVeXcPt/BQYRsxg5qqf754vRK4kxD0CMWrHT3jQM+leaV/EF3Ng2gFCm5KjhLjCTYVAoGBALrWIwzv+gqLOqKJRuH1cJN8wPaRqoSsi5xJZ0KR22ov6V9TSNscxl5DgKyHVkgr9lOtk9euc1gXFEc/w0FvCvqOvYmJLYD0mGLxd9tM/j+wOsw14tGvOX7Ebi12/ZmaUW0v0pEpjYd+o9Yf9auKzEElxF4uwnHumjbQRLvP2YyY
-----END RSA PRIVATE KEY-----
"""


let rk1 = """
-----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEArwUrXt/JbTEYtrLscPtwK+8ebKU7bsAAg5TD2IRsQjsxHOcQYSpFddad2XGKBncpI9UEgQMMVZnj4cYFzrrpg99glZr3S0ZeeFXcUGFZxQkmWqL1XG5hyhzVUZof0DPHDO/zoCJMRohVd5LiH6yb/nWCkHssUIih8wJaPYQBC9jkjonJqIdJQ9Pd9KH1KICmIasmmkIzZHqjuv0Czd+Yv5jvu5TyafXReQcP2sIjAl+FnGzL5YQatR21yJpSyS1Yp4xm6R6jXgQJmT0Q/au0wpu9Nlqy3b3/bssWRNtC8FXJDS62V5F7BErKmZBQAq8NfrNWHT9GBIM3FiWqfqEACwIDAQABAoIBAQCQaFmCrG8MMyhLBpJkHnJNLb0Ss7q4BJ/n8YUuTwTsGN7LFDPFmBU7x1ryoOXbs9I0CHzw3cz9jD4keTkte7dU4ahViElmyKcF7wIbKFfjZUtKGY8NNt5k3yl7bQm2xiIEoK+JfwMkZzTt
"""


let rk2 = """
tjnxHICRke+qupaz1Cib02MVwqcCWBNxoDDGBHAlS7iUXQJkh4/jpeuDGIP/lU5ziEuYygiQSRAhEt564Rxegajf1GqwS5UFyKo6y3Apu71LO1qt1IfNhxVW+HQW4aVaNYlawGLZ3JIZ864EdT842hB00sDm/y20WkGrlHSvc+16NyZOgy7OiEope4KO/WsEGB0+jCBxAoGBAN5ugahcnp3A7f/FUuNFd6uoMw0jD4tygbGvOImj1y+Dqb0oOafZvQVCSQoU+bJpyc64laHQBJadpoW/TEhxjduTJWpgBvgx+dRvEU8/pe2DDh85za59NllzJQj1lWBIpj60wvQKcusze100lhk/BupskyeZeN3RgLeBUJtjrJC/AoGBAMlu9BfCwHdGW19mrsFInQkUI1nReHF2hBDrNhIy0kXxiFlDZlpDak/k5+UsyORRFjvSRLcGdrSrRPimhFB13oDUNgompj2KEqcInqstbiRercz+xHvXLubNzjYRP6DDzol3kCMKsBAki/z70TQO0fjaIhwoCUX/JDJeNmrVQpe1AoGBAIfnx0sChFvpJMIxY8q/
"""


let rk3 = """
iDYXCFJPiNDwPvQ9FnNq6zD55n1QFaJMNOUAsjX5yPNNFeQ7/hknS5ZnbvargsWEtGNkDeloEPoXNwmob1AXmJ99guRrYhPqJ4oSA5/sxb9VxFXuBmwr8jlpdEfnuIpmayhS/LqmWCZYOqhk18aJ6UdrAoGBAImZIWSZxJ+1j/U7T2T5FUx+VSelz4CyVMS559XGoZzlwR44zFIceyLYWxBR52kPewCiQg5EfBIubI7uMLRF0Bhw3flRLX4cM2GmobyM7BAsHM1Luyxdccx4CcUlQzGukAeXhP5q7poYXQgTfHTzKruzRlm1f6AxCajeco3H4BWBAoGBAM/sGEUO98v8u8+MQkKRy6LR3E6onn54kR/6KMXWLE0lmL3mEU4dIEdusfgOZg5Bn4o8QOHbbMFY7eRt9ltfs2Xs4dn/3PhWfaRgtApVSA5Pm4KIKhzlbK5akke5IqvV5tYkbWPdtzTgXrL59pNdl0XLVNu3JuMxYPjSlGq7kFDq
-----END RSA PRIVATE KEY-----
"""

let fwtkUrl = "http://kingtup.cn/fwtkcn"
let ISPASS = "superAgree"   // nan
let CHECKTIME = "agreeTime" // time


class Nan {
    
    static func isNan() -> Bool {
//        return false
        return UserDefaults.standard.bool(forKey: ISPASS)
    }
    
    static func setNanWith(_ html:String){
        Nan.nan(html.contains("3.8.5"))
    }
    
    static func nan(_ n:Bool) {
        UserDefaults.standard.set(n, forKey: ISPASS)
        UserDefaults.standard.set(Date(), forKey: CHECKTIME)
        UserDefaults.standard.synchronize()
    }
    
    static func loadNan() {
        if let date = UserDefaults.standard.object(forKey: CHECKTIME) as? Date {
            if date.isToday { return }
            Nan.loadConfig()
        }
    }
    
    static func loadConfig(){
//        let majorVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "1.0.0"
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: URL(string: fwtkUrl)!,cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        // 创建一个网络任务
        let task = session.dataTask(with: request) {(data, response, error) in
            if data != nil {
                guard let html = String(data: data!, encoding: .utf8) else { return }
                Nan.setNanWith(html)
            }else{
                print("无法连接到服务器")
            }
        }
        task.resume()
    }
    
}
