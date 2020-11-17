import CCurl

@discardableResult
func curl_setopt(_ curl: UnsafeMutableRawPointer?, _ p: CURLoption, _ url: String) -> CURLcode {
    curl_easy_setopt_str(curl, p, url)
}

@discardableResult
func curl_setopt(_ curl: UnsafeMutableRawPointer?, _ p: CURLoption, _ v: Int) -> CURLcode {
    curl_easy_setopt_long(curl, p, v)
}