import XCTest

@testable import Request

final class RequestTests: XCTestCase {
    func testHttpGet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // for en in String.availableStringEncodings {
        //     print("\(en): \(en.rawValue)")
        // }
        // String init?(data: Data, encoding: String.Encoding)

        do {
            let res = try Request.get(url: "http://example.com")
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(url: "http://example.com", allowRedirects: true)
            XCTAssert(res.text.count > 0)
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(
                url: "http://example.com", params: [("foo", "bar"), ("foo", "?"), ("foo1", "神仙")],
                allowRedirects: true)
            XCTAssertEqual(res.url, "http://example.com/?foo=bar&foo=%3F&foo1=%E7%A5%9E%E4%BB%99")
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(url: "http://example.com", allowRedirects: true)
            XCTAssertEqual(res.url, "http://example.com/")
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.get(
                url: "http://example.com", auth: "james:bond", allowRedirects: true)
            XCTAssertEqual(res.url, "http://example.com/")
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        // >>> payload = {'key1': 'value1', 'key2': 'value2'}
        // >>> r = requests.get('https://httpbin.org/get', params=payload)
        do {
            let payload = [("key1", "value1"), ("key2", "value2")]
            let res = try Request.get(url: "https://httpbin.org/get", params: payload)
            XCTAssertEqual(res.url, "https://httpbin.org/get?key1=value1&key2=value2")
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        do {
            let payload = [("key1", "value1"), ("key2", "value2")]
            let res = try Request.get(url: "https://httpbin.org/get", params: payload)
            XCTAssertEqual(res.url, "https://httpbin.org/get?key1=value1&key2=value2")

        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        

        do {
            let payload = [("name1", "value1"), ("name2", "value2")]
            let res = try Request.get(url: "http://httpbin.org/cookies/set", params: payload)
            XCTAssert(res.cookies.count > 0)

        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

    }

    func testHttpPost() {
        do {
            let res = try Request.post(
                url: "https://httpbin.org/post", data: "name=daniel&email=测试")
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.post(
                url: "https://httpbin.org/post",
                data: "Test Suite 'All tests' started at 2020-11-22 00:17:00.188",
                headers: ["Content-Type": "text/plain"])
            XCTAssertEqual(res.statusCode, 200)
        } catch let error as RequestError {
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
            print("\(res.headers)")
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }

        do {
            let res = try Request.post(
                url: "https://httpbin.org/post", files: [.fileFiled("upload_file", "/home/color/Pictures/celluloid-shot0001.jpg"), .textFiled("upload_file", "file")])
            XCTAssertEqual(res.statusCode, 200)
            
        } catch let error as RequestError {
            print(error.msg)
        } catch {

        }
    }

    static var allTests = [
        ("testHttpGet", testHttpGet),
        ("testHttpPost", testHttpPost),
    ]
}
