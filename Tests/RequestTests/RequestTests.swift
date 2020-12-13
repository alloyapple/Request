import XCTest

@testable import Request

final class RequestTests: XCTestCase {
    func testHttpGet() {
        print("curl version: \(curlVerson)")
        do {
            let res = try Request.get(url: "http://example.com")
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(url: "http://example.com", allowRedirects: true)
            XCTAssert(res.text.count > 0)
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(
                url: "http://example.com", params: [("foo", "bar"), ("foo", "?"), ("foo1", "神仙")],
                allowRedirects: true)
            XCTAssertEqual(res.url, "http://example.com/?foo=bar&foo=%3F&foo1=%E7%A5%9E%E4%BB%99")
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(url: "http://example.com", allowRedirects: true)
            XCTAssertEqual(res.url, "http://example.com/")
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(
                url: "http://example.com", auth: "james:bond", allowRedirects: true)
            XCTAssertEqual(res.url, "http://example.com/")
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        // >>> payload = {'key1': 'value1', 'key2': 'value2'}
        // >>> r = requests.get('https://httpbin.org/get', params=payload)
        do {
            let payload = [("key1", "value1"), ("key2", "value2")]
            let res = try Request.get(url: "https://httpbin.org/get", params: payload)
            XCTAssertEqual(res.url, "https://httpbin.org/get?key1=value1&key2=value2")
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let payload = [("key1", "value1"), ("key2", "value2")]
            let res = try Request.get(url: "https://httpbin.org/get", params: payload)
            XCTAssertEqual(res.url, "https://httpbin.org/get?key1=value1&key2=value2")

        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let payload = [("name1", "value1"), ("name2", "value2")]
            let res = try Request.get(url: "http://httpbin.org/cookies/set", params: payload)
            XCTAssert(res.cookies.count > 0)
            XCTAssert(res.headers.count > 0)

        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        struct Github: Decodable {
            var current_user_url: String
        }

        do {

            let res = try Request.get(url: "https://api.github.com")
            let g: Github = try res.json()
            XCTAssertEqual("https://api.github.com/user", g.current_user_url)

        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

    }

    func testHttpPost() {
        do {
            let res = try Request.post(
                url: "https://httpbin.org/post", data: "name=daniel&email=测试")
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.post(
                url: "https://httpbin.org/post",
                data: "Test Suite 'All tests' started at 2020-11-22 00:17:00.188",
                headers: ["Content-Type": "text/plain"])
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let payload = """
                {"hello": "word"}
                """
            let res = try Request.post(
                url: "https://httpbin.org/post", json: payload.data(using: .utf8))
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.post(
                url: "https://httpbin.org/post",
                files: [
                    .fileFiled("upload_file", "/home/color/Pictures/celluloid-shot0001.jpg"),
                    .textFiled("upload_file", "file"),
                ])
            XCTAssertEqual(res.statusCode, 200)

        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }
    }

    func testHttpSession() {
        do {
            let s = Session()
            let res = try s.get(url: "http://example.com")
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }
    }

    func testDownload() {
        do {
            let res = try Request.download(
                url:
                    "https://static.cnbetacdn.com/thumb/article/2020/1210/87786a7407e8d2f.jpg"
            ) { (data, percent, msg) in
                print("下载数据长度：\(data.count)  download: \(100 * percent)")
            }
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as HTTPError {
            print(error.msg)
        } catch {

        }

    }

    static var allTests = [
        ("testHttpGet", testHttpGet),
        ("testHttpPost", testHttpPost),
        ("testHttpSession", testHttpSession),
        ("testDownload", testDownload),
    ]
}
