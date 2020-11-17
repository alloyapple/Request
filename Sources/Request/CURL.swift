import CCurl

@discardableResult
func curl_setopt(_ curl: UnsafeMutableRawPointer?, _ p: CURLoption, _ url: String) -> CURLcode {
    curl_easy_setopt_str(curl, CURLOPT_URL, url)
}