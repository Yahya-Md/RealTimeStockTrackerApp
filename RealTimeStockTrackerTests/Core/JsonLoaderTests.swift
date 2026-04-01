//
//  JsonLoaderTests.swift
//  RealTimeStockTrackerTests
//

import XCTest
import RealTimeStockTracker

final class JsonLoaderTests: XCTestCase {
    
    private class User: Decodable {
        let id: Int
        let name: String
        
        init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    func testFetch_Success_onFoundedFileWithValidJson() async throws {
        let sut = makeSUT()
        let result = User(id: 1, name: "test")
        let user: User = try await sut.fetch(for: "mock")
        
        XCTAssertEqual(user.id, result.id)
        XCTAssertEqual(user.name, result.name)
    }
    
    func testFetch_Error_onNotFoundedFile() async throws {
        let sut = makeSUT()
        await expect(sut: sut, fileName: "something", withError: .fileNotFound)
    }
    
    func testFetch_Error_onFoundedFileWithInvalidJson() async {
        let sut = makeSUT()
        await expect(sut: sut, fileName: "invalid", withError: .failedToDecode)
    }
}

extension JsonLoaderTests {
    func makeSUT() -> JsonLoader {
        return JsonLoader(bundle: Bundle(for: JsonLoaderTests.self))
    }
    
    func expect(sut: JsonLoader,
                fileName: String,
                withError expectedError: JsonLoader.JsonLoaderError,
                file: StaticString = #filePath,
                line: UInt = #line
    ) async {
        do {
            let _: User = try await sut.fetch(for: fileName)
            XCTFail("Expected to get error \(expectedError)", file: file, line: line)
        } catch let error as JsonLoader.JsonLoaderError {
            XCTAssertEqual(error, expectedError, file: file, line: line)
        } catch {
            XCTFail("Wrong error type: \(error) instead of \(expectedError)", file: file, line: line)
        }
    }
}
