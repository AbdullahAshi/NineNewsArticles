//
//  NetworkServiceTests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

@testable import NineNewsArticles
import XCTest

class NetworkServiceTests: XCTestCase {
    let anyUrl = URL(string: "https://www.google.com")!
    let mockUrlSession = MockURLSession()
    lazy var networkService = NetworkService(urlSession: mockUrlSession)
    
    func testSuccess() throws {
        let response: Response = .init(id: "123451")
        let data: Data = try JSONEncoder().encode(response)
        mockUrlSession.set(mockInfo: (data: data, statusCode: 200, error: nil))
        let expectation = XCTestExpectation(description: "error should be nil, and response shouldn't be nil")
        networkService.get(url: anyUrl, completion: { (response: Response?, error) in
            XCTAssertNotNil(response, "response is not expected to be nil")
            XCTAssertNil(error, "error should be nil")
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
    
    func testFail() throws {
        mockUrlSession.set(mockInfo: (data: Data(), statusCode: 404, error: nil))
        
        let expectation = XCTestExpectation(description: "error should be nil, and response shouldn't be nil")

        networkService.get(url: anyUrl, completion: { (response: Response?, error) in
            XCTAssertNil(response, "response is expected to be nil")
            let networkError = (error as? NetworkError)
            XCTAssertEqual(networkError, NetworkError.invalidResponse("unsuccessful status code"))
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
}

// MARK: - Test Model

private extension NetworkServiceTests {

    struct Response: Codable {

        enum CodingKeys: CodingKey {
            case id
        }

        let id: String
    }
}


class MockURLSession: URLSessionProtocol {
    
    typealias MockInfo = (data: Data?, statusCode: Int, error: Error?)
    
    private (set) var nextDataTask = MockURLSessionDataTask()
    private var mockInfo: MockInfo?
    
    private var mockResponse: HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: mockInfo!.statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        nextDataTask.resume()
        if let mockInfo = mockInfo {
            completionHandler(mockInfo.data, mockResponse, mockInfo.error)
        } else {
            completionHandler(Data(), mockResponse, nil)
        }
        return nextDataTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        nextDataTask.resume()
        if let mockInfo = mockInfo {
            completionHandler(mockInfo.data, mockResponse, mockInfo.error)
        } else {
            completionHandler(Data(), mockResponse, nil)
        }
        return nextDataTask
    }
    
    
    func set(mockInfo: MockInfo) {
        self.mockInfo = mockInfo
    }
    
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeCalled = false
    
    func resume() {
        resumeCalled = true
    }
}

extension URLResponse {
    static func mock(url: URL = URL(string: "https://www.google.com")!,
                     statusCode: Int = 200,
                     httpVersion: String? = nil,
                     headerFields: [String: String]? = nil) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)!
    }
}
