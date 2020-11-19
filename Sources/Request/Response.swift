import CCurl
import Foundation

class Response {
    public let request: Request
    var content: Data = Data()

    var statusCode: Int {
        return curl_easy_status_code(request.curl)
    }

    var redirectURL: String {
        if let url = curl_get_redirect_url(request.curl) {
            defer {
                free(url)
            }
            return String(cString: url); 
        } else {
            return ""
        }
    }

    var url: String {
        if let url = curl_get_effective_url(request.curl) {
            defer {
                free(url)
            }
            return String(cString: url); 
        } else {
            return ""
        }
        
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