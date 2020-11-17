import Foundation 
import CCurl

class Request {
    private let curl: UnsafeMutableRawPointer?
    public static func get(url: String) throws -> Response {
        let r = Request(method: .GET, url: url)
        return r.perform()
    }

    public static func post(url: String) throws -> Response {
        let r = Request(method: .POST, url: url)
        return r.perform()
    }

    public static func put(url: String) throws -> Response {
        let r = Request(method: .PUT, url: url)
        return r.perform()
    }

    public  init(method: HttpMethod, url: String, params: [String: String] = [:],
                        data: Data? = nil, json: Data? = nil, headers: [String: String] = [:], 
                        cookies: [String: String] = [:], files: [String] = [], auth: String = "", 
                        timeout: Float = 0, allowRedirects: Bool = false, proxies: String? = nil, 
                        verify: Bool = false, cert: String = "") {
        curl_global_init(Int(CURL_GLOBAL_ALL))
        self.curl = curl_easy_init()
        curl_setopt(self.curl, CURLOPT_URL, url)
    }

    public func perform() -> Response {
        return Response(self)
    }

    deinit {
        curl_easy_cleanup(self.curl)
    }
}