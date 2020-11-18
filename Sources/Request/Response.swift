import CCurl
import Foundation
class Response {
    public let request: Request
    var content: Data = Data()

    var statusCode: Int {
        return curl_easy_status_code(request.curl)
    }

    var text: String {
        return String(decoding: content, as: UTF8.self)
    }

    public init(_ r: Request) {
        self.request = r
    }

    func writeData(_ data: Data){
        self.content.append(data)
    }


}