import Foundation


class Session {
    public var cookies: [String] = []
    let cookie: String
    

    init(cookieDir: String = "./") {
        self.cookie = cookieDir + ProcessInfo.processInfo.globallyUniqueString
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
                allowRedirects: allowRedirects, cookie: cookie, debug: debug)
            cookies = res.cookies
            return res
        }
    }

    func post() {

    }

    func head() {

    }

    deinit {
        do {
            try FileManager.default.removeItem(atPath: self.cookie)
        } catch {
            
        }
        
    }
}
