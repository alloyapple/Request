import Foundation 

class Request {

    public static func get() throws -> Response {
        return Response()
    }

    public static func post() throws -> Response {
        return Response()
    }

    public static func put() throws -> Response {
        return Response()
    }

    public  init(method: HttpMethod, url: String, params: [String: String],
                        data: Data, json: Data, headers: [String: String], 
                        cookies: [String: String], files: [String], auth: String, 
                        timeout: Float, allowRedirects: Bool, proxies: String, 
                        verify: Bool, cert: String) {

    }
}