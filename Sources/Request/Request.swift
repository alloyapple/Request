import CCurl
import Foundation

public enum Mime {
    case textFiled(_ name: String, _ data: String)
    case fileFiled(_ name: String, _ data: String)
}

//参数分别是下载的数据，下载进度，错误信息
typealias DownloadCompleteHandler = (Data, Float, String) -> Void

extension UnsafeMutableRawPointer {
    public func unretainedValue<T: AnyObject>() -> T {
        return Unmanaged<T>.fromOpaque(self).takeUnretainedValue()
    }

    public func retainedValue<T: AnyObject>() -> T {
        return Unmanaged<T>.fromOpaque(self).takeRetainedValue()
    }
}

func creadHandler(
    dest: UnsafeMutablePointer<UInt8>?, size: Int, nmemb: Int, userData: UnsafeMutableRawPointer?
) -> Int {
    if let userData = userData, let dest = dest {
        let request: Request = userData.unretainedValue()
        let left = request.readPostData(dest, size * nmemb)
        return left
    }
    return 0
}

func cwriteHandler(
    dest: UnsafeMutablePointer<UInt8>?, size: Int, nmemb: Int, userData: UnsafeMutableRawPointer?
) -> Int {
    if let userData = userData, let dest = dest {
        let response: Response = userData.unretainedValue()
        response.writeData(Data(bytes: dest, count: size * nmemb))
    }

    return size * nmemb
}

func cheadHandler(
    dest: UnsafeMutablePointer<UInt8>?, size: Int, nmemb: Int, userData: UnsafeMutableRawPointer?
) -> Int {
    if let userData = userData, let contents = dest {
        let response: Response = userData.unretainedValue()
        response.writeHeader(Data(bytes: contents, count: size * nmemb))
    }

    return size * nmemb
}

func cprogressHandler(
    userData: UnsafeMutableRawPointer?, dltotal: Double, dlnow: Double, ultotal: Double,
    ulnow: Double
) -> Int32 {
    if let userData = userData {
        let response: Response = userData.unretainedValue()
        response.dltotal = dltotal
        response.dlnow = dlnow
        response.ultotal = ultotal
        response.ulnow = ulnow
    }

    return 1
}

let readHandler:
    @convention(c) (UnsafeMutablePointer<UInt8>?, Int, Int, UnsafeMutableRawPointer?) -> Int =
        creadHandler
let writeHandler:
    @convention(c) (UnsafeMutablePointer<UInt8>?, Int, Int, UnsafeMutableRawPointer?) -> Int =
        cwriteHandler
let headHandler:
    @convention(c) (UnsafeMutablePointer<UInt8>?, Int, Int, UnsafeMutableRawPointer?) -> Int =
        cheadHandler

let progressHandler:
    @convention(c) (UnsafeMutableRawPointer?, Double, Double, Double, Double) -> Int32 =
        cprogressHandler

public let curlVerson: String = {
    String(cString: curl_version())
}()

let defaultHeaders: [String: String] = [
    "User-Agent": "\(curlVerson)",
    //"Accept-Encoding": "gzip, deflate",
    "Accept": "*/*",
    "Connection": "keep-alive",
]
class Request {
    public let curl: UnsafeMutableRawPointer?
    public var formData: Data?
    private var mimeForm: OpaquePointer? = nil
    private var headerList: UnsafeMutablePointer<curl_slist>?
    public static func get(
        url: String, params: [(String, CustomStringConvertible)] = [],
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        cookie: String? = nil,
        debug: Bool = false
    ) throws -> Response {
        let r = Request(
            method: .GET, url: url, params: params, headers: headers, cookie: cookie, auth: auth,
            allowRedirects: allowRedirects, debug: debug)
        return try r.perform(res: Response(r))
    }

    public static func post(
        url: String, data: String? = nil, json: Data? = nil,
        files: [Mime]? = nil,
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        debug: Bool = false
    ) throws -> Response {
        let r = Request(
            method: .POST, url: url, data: data, json: json, files: files, headers: headers,
            auth: auth, allowRedirects: allowRedirects, debug: debug)
        return try r.perform(res: Response(r))
    }

    public static func put(
        url: String,
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        cookie: String? = nil,
        debug: Bool = false
    ) throws -> Response {
        let r = Request(
            method: .PUT, url: url, headers: headers, cookie: cookie, auth: auth,
            allowRedirects: allowRedirects, debug: debug)
        return try r.perform(res: Response(r))
    }

    public static func head(
        url: String,
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        cookie: String? = nil,
        debug: Bool = false
    ) throws -> Response {
        let r = Request(
            method: .HEAD, url: url, headers: headers, cookie: cookie, auth: auth,
            allowRedirects: allowRedirects, debug: debug)
        return try r.perform(res: Response(r))
    }

    public static func delete(
        url: String,
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        cookie: String? = nil,
        debug: Bool = false
    ) throws -> Response {
        let r = Request(
            method: .DELETE, url: url, headers: headers, cookie: cookie, auth: auth,
            allowRedirects: allowRedirects, debug: debug)
        return try r.perform(res: Response(r))
    }

    public static func patch(
        url: String,
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        cookie: String? = nil,
        debug: Bool = false
    ) throws -> Response {
        let r = Request(
            method: .PATCH, url: url, headers: headers, cookie: cookie, auth: auth,
            allowRedirects: allowRedirects, debug: debug)
        return try r.perform(res: Response(r))
    }

    public static func options(
        url: String,
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        cookie: String? = nil,
        debug: Bool = false
    ) throws -> Response {
        let r = Request(
            method: .OPTIONS, url: url, headers: headers, cookie: cookie, auth: auth,
            allowRedirects: allowRedirects, debug: debug)
        return try r.perform(res: Response(r))
    }

    public static func download(
        url: String,
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        cookie: String? = nil,
        debug: Bool = false,
        downloadCompleteHandler: @escaping DownloadCompleteHandler
    ) throws -> Response {
        let r = Request(
            method: .GET, url: url, headers: headers, cookie: cookie, auth: auth,
            allowRedirects: allowRedirects, debug: debug)
        let res = Response(r)
        res.downloadCompleteHandler = downloadCompleteHandler
        return try r.perform(res: res)
    }

    public init(
        method: HttpMethod, url: String, params: [(String, CustomStringConvertible)] = [],
        data: String? = nil, json: Data? = nil, files: [Mime]? = nil,
        headers: [String: CustomStringConvertible] = [:],
        cookie: String? = nil, auth: String? = nil,
        timeout: Float = 0, allowRedirects: Bool = false, proxies: String? = nil,
        verify: Bool = false, cert: String = "", debug: Bool = false
    ) {
        curl_global_init(Int(CURL_GLOBAL_ALL))
        self.curl = curl_easy_init()
        curl_setopt(curl, CURLOPT_TRANSFER_ENCODING, 1)

        if let cookie = cookie {
            curl_setopt(curl, CURLOPT_COOKIEFILE, cookie)
            curl_setopt(curl, CURLOPT_COOKIEJAR, cookie)
        }

        curl_setopt(curl, CURLOPT_COOKIEFILE, "")

        if allowRedirects {
            curl_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
        }

        if debug {
            curl_setopt(curl, CURLOPT_VERBOSE, 1)
        }

        var _url = url

        if params.count > 0 {
            var result: [String] = []
            for (k, v) in params {
                let ck = String(cString: curl_easy_escape(nil, "\(k)", Int32(k.utf8.count)))
                let cv = String(
                    cString: curl_easy_escape(nil, "\(v)", Int32(v.description.utf8.count)))
                result.append("\(ck)=\(cv)")
            }
            let ps = "?" + result.joined(separator: "&")
            _url += ps
        }

        switch method {
        case .POST:
            curl_setopt(curl, CURLOPT_POST, 1)
        case .PUT:
            curl_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT")
        case .HEAD:
            curl_setopt(curl, CURLOPT_CUSTOMREQUEST, "HEAD")
        case .DELETE:
            curl_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE")
        case .OPTIONS:
            curl_setopt(curl, CURLOPT_CUSTOMREQUEST, "OPTIONS")
        case .PATCH:
            curl_setopt(curl, CURLOPT_CUSTOMREQUEST, "PATCH")
        default:
            break
        }

        var _headers = headers
        if let json = json {
            _headers["Content-Type"] = "application/json"
            _headers["charset"] = "utf-8"
            self.formData = json
        }

        if let _ = files {
            _headers["Expect"] = ""
        }

        _headers.merge(defaultHeaders, uniquingKeysWith: { (_, last) in last })

        var headerList: UnsafeMutablePointer<curl_slist>? = nil
        _headers.forEach { (item) in
            headerList = curl_slist_append(headerList, "\(item.key):\(item.value)")
        }
        curl_setopt(self.curl, CURLOPT_HTTPHEADER, headerList)
        self.headerList = headerList

        if let auth = auth {
            curl_setopt(curl, CURLOPT_HTTPAUTH, curlauth_any)
            curl_setopt(curl, CURLOPT_USERPWD, auth)
        }

        if let data = data {
            self.formData = data.data(using: .utf8)
        }

        if let files = files {
            self.mimeForm = curl_mime_init(curl)
            files.forEach { (item) in
                switch item {
                case .textFiled(let name, let data):
                    let field = curl_mime_addpart(self.mimeForm)
                    curl_mime_name(field, name)
                    curl_mime_data(field, data, CURL_ZERO_TERMINATED)
                case .fileFiled(let name, let data):
                    let field = curl_mime_addpart(self.mimeForm)
                    curl_mime_name(field, name)
                    curl_mime_filedata(field, data)
                }
            }

            curl_setopt(curl, CURLOPT_MIMEPOST, self.mimeForm)
        }

        curl_setopt(self.curl, CURLOPT_URL, _url)

    }

    public func perform(res: Response) throws -> Response {
        //如果执行成功，数据都写入到res中

        let requestUnmanaged = Unmanaged.passRetained(self)
        curl_setopt(self.curl, CURLOPT_READFUNCTION, readHandler)
        curl_setopt(self.curl, CURLOPT_READDATA, requestUnmanaged)

        defer {
            requestUnmanaged.release()
        }

        let responseUnmanaged = Unmanaged.passRetained(res)
        curl_setopt(self.curl, CURLOPT_WRITEFUNCTION, writeHandler)
        curl_setopt(self.curl, CURLOPT_WRITEDATA, responseUnmanaged)

        curl_setopt(self.curl, CURLOPT_HEADERFUNCTION, headHandler)
        curl_setopt(self.curl, CURLOPT_HEADERDATA, responseUnmanaged)

        curl_setopt(self.curl, CURLOPT_PROGRESSFUNCTION, progressHandler)
        curl_setopt(self.curl, CURLOPT_PROGRESSDATA, responseUnmanaged)

        defer {
            responseUnmanaged.release()
        }

        let r = curl_easy_perform(self.curl)

        if r == CURLE_OK {
            return res
        } else {
            let e = String(cString: curl_easy_strerror(r))
            throw HTTPError.msg(txt: e)
        }

    }

    func readPostData(_ buffer: UnsafeMutablePointer<UInt8>, _ size: Int) -> Int {
        if let postData = self.formData, postData.count > 0 {
            let c = min(postData.count, size)
            postData.copyBytes(to: buffer, count: c)
            self.formData = self.formData?.dropFirst(c)
            return c
        }

        return 0
    }

    deinit {
        //print("request deinit")
        curl_easy_cleanup(self.curl)
        curl_mime_free(self.mimeForm)
        curl_slist_free_all(self.headerList)

    }
}
