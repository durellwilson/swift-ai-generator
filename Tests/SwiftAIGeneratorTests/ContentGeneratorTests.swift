import XCTest
@testable import SwiftAIGenerator

final class ContentGeneratorTests: XCTestCase {
    func testGenerateContent() async throws {
        let generator = ContentGenerator()
        
        let content = try await generator.generate(topic: .swiftUI)
        
        XCTAssertFalse(content.title.isEmpty)
        XCTAssertFalse(content.body.isEmpty)
        XCTAssertFalse(content.codeSnippet.isEmpty)
        XCTAssertFalse(content.tags.isEmpty)
    }
    
    func testGenerateBatch() async throws {
        let generator = ContentGenerator()
        
        let contents = try await generator.generateBatch(count: 5, topics: [.swiftUI, .swiftData])
        
        XCTAssertEqual(contents.count, 5)
        XCTAssertTrue(contents.allSatisfy { !$0.title.isEmpty })
    }
    
    func testGenerationCount() async throws {
        let generator = ContentGenerator()
        
        _ = try await generator.generate(topic: .swiftUI)
        _ = try await generator.generate(topic: .swiftData)
        
        let count = await generator.getGenerationCount()
        XCTAssertEqual(count, 2)
    }
    
    func testAllTopics() async throws {
        let generator = ContentGenerator()
        
        for topic in Topic.allCases {
            let content = try await generator.generate(topic: topic)
            XCTAssertFalse(content.title.isEmpty)
        }
    }
}
