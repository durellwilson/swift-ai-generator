import XCTest
@testable import SwiftAIGenerator

final class ImpactTrackerTests: XCTestCase {
    func testRecordContribution() async throws {
        let tracker = ImpactTracker()
        
        await tracker.recordContribution(.post)
        await tracker.recordContribution(.comment)
        
        let metrics = await tracker.getMetrics()
        XCTAssertEqual(metrics.totalContributions, 2)
        XCTAssertEqual(metrics.postsCreated, 1)
        XCTAssertEqual(metrics.commentsAdded, 1)
    }
    
    func testRecordLearning() async throws {
        let tracker = ImpactTracker()
        
        await tracker.recordLearning(topic: .swiftUI, timeSpent: 60)
        
        let metrics = await tracker.getMetrics()
        XCTAssertEqual(metrics.learningHours, 1.0)
        XCTAssertTrue(metrics.topicsLearned.contains("SwiftUI"))
    }
    
    func testCalculateImpactScore() async throws {
        let tracker = ImpactTracker()
        
        await tracker.recordContribution(.post)
        await tracker.recordContribution(.helpProvided)
        await tracker.recordLearning(topic: .swiftUI, timeSpent: 120)
        
        let score = await tracker.calculateImpactScore()
        XCTAssertGreaterThan(score, 0)
    }
}
