import XCTest
@testable import SwiftAIGenerator

final class AutoUpgraderTests: XCTestCase {
    func testAnalyzeProject() async throws {
        let upgrader = AutoUpgrader()
        
        let recommendations = try await upgrader.analyzeProject(at: "/test/path")
        
        XCTAssertNotNil(recommendations)
        XCTAssertEqual(recommendations.projectPath, "/test/path")
    }
    
    func testApplyUpgrade() async throws {
        let upgrader = AutoUpgrader()
        
        try await upgrader.applyUpgrade(.addTesting, to: "/test/path")
        
        let history = await upgrader.getUpgradeHistory()
        XCTAssertEqual(history.count, 1)
    }
    
    func testUpgradeHistory() async throws {
        let upgrader = AutoUpgrader()
        
        try await upgrader.applyUpgrade(.addTesting, to: "/path1")
        try await upgrader.applyUpgrade(.addCI, to: "/path2")
        
        let history = await upgrader.getUpgradeHistory()
        XCTAssertEqual(history.count, 2)
    }
}
