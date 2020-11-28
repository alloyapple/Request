class Session {
    public var cookies: [String] = []
    func get(
        url: String, params: [(String, CustomStringConvertible)] = [],
        headers: [String: CustomStringConvertible] = [:],
        auth: String? = nil,
        allowRedirects: Bool = false,
        debug: Bool = false
    ) throws -> Response {
        do {
            let res = try Request.get(
                url: url, params: params, headers: headers, auth: auth,
                allowRedirects: allowRedirects, cookies: cookies, debug: debug)
            cookies = res.cookies
            return res
        }
    }

    func post() {

    }

    func head() {

    }
}
