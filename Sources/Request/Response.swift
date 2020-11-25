import CCurl
import Foundation

extension String.Encoding {
    static let gb2312 = String.Encoding(rawValue: 2_147_485_234)
}

class Response {
    public let request: Request
    var content: Data = Data()
    var headData: Data = Data()
    var cookies: [String] {
        var list = curl_get_cookie(request.curl)
        let nc = list

        var result: [String] = []

        while list != nil {
            let c = String(cString: list!.pointee.data)
            list = list?.pointee.next
            result.append(c)
        }

        curl_slist_free_all(nc)

        return result
    }

    var statusCode: Int {
        return curl_easy_status_code(request.curl)
    }

    var headers: String {
        return String(decoding: headData, as: UTF8.self)
    }

    var redirectURL: String {
        if let url = curl_get_redirect_url(request.curl) {
            defer {
                free(url)
            }
            return String(cString: url)
        } else {
            return ""
        }
    }

    var url: String {
        if let url = curl_get_effective_url(request.curl) {
            return String(cString: url)
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

    func writeData(_ data: Data) {
        self.content.append(data)
    }

    func writeHeader(_ data: Data) {
        self.headData.append(data)
    }

    func json<T>() throws -> T where T: Decodable {
        let t = try JSONDecoder().decode(T.self, from: content) as T
        return t
    }

    deinit {
        //print("response deinit")
    }

}
