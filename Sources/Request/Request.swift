import Foundation 
import CCurl


public extension UnsafeMutableRawPointer {
    func unretainedValue<T: AnyObject>() -> T {
        return Unmanaged<T>.fromOpaque(self).takeUnretainedValue()
    }

    func retainedValue<T: AnyObject>() -> T {
        return Unmanaged<T>.fromOpaque(self).takeRetainedValue()
    }
}

func creadHandler(dest: UnsafeMutablePointer<Int8>?, size: Int, nmemb: Int, userData: UnsafeMutableRawPointer?) -> Int {
    print("cread")
    return 0
}



func cwriteHandler(dest: UnsafeMutablePointer<Int8>?, size: Int, nmemb: Int, userData: UnsafeMutableRawPointer?) -> Int {
    if let userData = userData, let contents = dest {
        let request: Response = userData.unretainedValue()
        request.writeData(Data(bytes: contents, count: size * nmemb))
    }

    return size * nmemb
}

let readHandler: @convention(c) (UnsafeMutablePointer<Int8>?, Int, Int, UnsafeMutableRawPointer?) -> Int = creadHandler
let writeHandler: @convention(c) (UnsafeMutablePointer<Int8>?, Int, Int, UnsafeMutableRawPointer?) -> Int = cwriteHandler
let curlVerson: String = {
    String(cString: curl_version())
}()

let defaultHeaders: [String: String] = [
    "User-Agent": "\(curlVerson)",
    //"Accept-Encoding": "gzip, deflate",
    "Accept": "*/*",
    "Connection": "keep-alive"
]
class Request {
    public let curl: UnsafeMutableRawPointer?
    public static func get(url: String, params: [(String, CustomStringConvertible)] = [], headers: [String: CustomStringConvertible] = [:], allowRedirects: Bool = false) throws -> Response {
        let r = Request(method: .GET, url: url, params: params, headers: headers, allowRedirects: allowRedirects)
        return try r.perform()
    }

    public static func post(url: String) throws -> Response {
        let r = Request(method: .POST, url: url)
        return try r.perform()
    }

    public static func put(url: String) throws -> Response {
        let r = Request(method: .PUT, url: url)
        return try r.perform()
    }

    public  init(method: HttpMethod, url: String, params: [(String, CustomStringConvertible)] = [],
                        data: Data? = nil, json: Data? = nil, headers: [String: CustomStringConvertible] = [:], 
                        cookies: [String: CustomStringConvertible] = [:], files: [String] = [], auth: String = "", 
                        timeout: Float = 0, allowRedirects: Bool = false, proxies: String? = nil, 
                        verify: Bool = false, cert: String = "") {
        curl_global_init(Int(CURL_GLOBAL_ALL))
        self.curl = curl_easy_init()
        
        if allowRedirects {
            curl_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
        }

        var _url = url

        if params.count > 0 {
            var result: [String] = []
            for (k, v) in params {
                let ck = String(cString: curl_easy_escape(nil, "\(k)", Int32(strlen(k))))
                let cv = String(cString: curl_easy_escape(nil, "\(v)", Int32(strlen("\(v)"))))
                result.append("\(ck)=\(cv)")
            }
            let ps = "?" + result.joined(separator: "&")
            _url += ps
        }

        var _headers = headers
        _headers.merge(defaultHeaders, uniquingKeysWith: { (_, last) in last })

        var headerList: UnsafeMutablePointer<curl_slist>?  = nil
        _headers.forEach { (item) in
            headerList = curl_slist_append(headerList, "\(item.key):\(item.value)");
        }
        curl_setopt(self.curl, CURLOPT_HTTPHEADER, headerList)

        curl_setopt(self.curl, CURLOPT_URL, _url)

    }

    public func perform() throws ->  Response {
        //如果执行成功，数据都写入到res中
        let res = Response(self)

        curl_setopt(self.curl, CURLOPT_READFUNCTION, readHandler)
        curl_setopt(self.curl, CURLOPT_READDATA, res)

        curl_setopt(self.curl, CURLOPT_WRITEFUNCTION, writeHandler)
        curl_setopt(self.curl, CURLOPT_WRITEDATA, res)
        //curl_easy_setopt(self.curl, CURLOPT_TIMEOUT, Int(self.timeOut))

        let r = curl_easy_perform(self.curl)

        if r == CURLE_OK {
            return res
        } else {
            let e = String(cString: curl_easy_strerror(r))
            throw RequestError.msg(txt: e)
        }
        
    }

    deinit {
        curl_easy_cleanup(self.curl)
    }
}