import XCTest
@testable import Request

final class RequestTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
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
            let res = try Request.get(url: "http://example.com", params: [("foo", "bar"), ("foo", "?")], allowRedirects: true)
            XCTAssertEqual(res.url, "http://example.com/?foo=bar")
        } catch let error as RequestError {
            print(error.msg)
        } catch {
            
        }

        do {
            let res = try Request.get(url: "http://www.microsoft.com", allowRedirects: true)
            XCTAssertEqual(res.url, "https://www.microsoft.com/zh-cn/")
        } catch let error as RequestError {
            print(error.msg)
        } catch {
            
        }
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
