import CCurl

public typealias CCurlRWCallback = @convention(c) (UnsafeMutablePointer<Int8>?, Int, Int, UnsafeMutableRawPointer?) -> Int

@discardableResult
func curl_setopt(_ curl: UnsafeMutableRawPointer?, _ p: CURLoption, _ url: String) -> CURLcode {
    curl_easy_setopt_str(curl, p, url)
}

@discardableResult
func curl_setopt(_ curl: UnsafeMutableRawPointer?, _ p: CURLoption, _ v: Int) -> CURLcode {
    curl_easy_setopt_long(curl, p, v)
}


@discardableResult
func curl_setopt(_ handle: UnsafeMutableRawPointer?, _ option: CURLoption, _ value: @escaping CCurlRWCallback) -> CURLcode {
    return curl_easy_setopt_rw_callback(handle, option, value)
}

@discardableResult
func curl_setopt(_ handle: UnsafeMutableRawPointer?, _ option: CURLoption, _ value: UnsafeMutablePointer<curl_slist>?) -> CURLcode {
    return curl_easy_setopt_httpheader(handle, option, value)
}

@discardableResult
func curl_setopt(_ handle: UnsafeMutableRawPointer?, _ option: CURLoption, _ value: Response) -> CURLcode {
    return curl_easy_setopt_voidp(handle, option, Unmanaged.passRetained(value).toOpaque())
}