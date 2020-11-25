
enum HTTPError: Error {
    case msg(txt: String)
    var msg: String {
        switch self {
            case .msg(let msg):
                return msg
        }
    }
}
