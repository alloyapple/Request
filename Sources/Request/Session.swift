import Foundation

class Session {
    public var cookies: [String] = []
    let cookieDir: String
    let cookieFileName: String

    init(cookieDir: String = "./") {
        self.cookieDir = cookieDir
        self.cookieFileName = ProcessInfo.processInfo.globallyUniqueString
        /*
        curl_setopt($ch, CURLOPT_COOKIEFILE, dirname(__FILE__). '/cookie.txt'); //read cookies from here
        curl_setopt($ch, CURLOPT_COOKIEJAR, dirname(__FILE__) . '/cookie.txt'); //save cookies here
        */
    }

    func get(
        url: String, params: [(String, CustomStringConvertible)] = [],
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        debug: Bool = false
    ) throws -> Response {
        do {
            let res = try Request.get(
                url: url, params: params, headers: headers, auth: auth,
                allowRedirects: allowRedirects, cookies: cookies, debug: debug)
            cookies = res.cookies
            return res
        }
    }

    func post() {

    }

    func head() {

    }
}
