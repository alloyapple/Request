import CCurl
class Response {
    public let request: Request

    var statusCode: Int {
        return curl_easy_status_code(request.curl)
    }

    public init(_ r: Request) {
        self.request = r
    }


}