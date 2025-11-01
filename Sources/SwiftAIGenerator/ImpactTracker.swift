import Foundation

public actor ImpactTracker {
    private var metrics: ImpactMetrics
    
    public init() {
        self.metrics = ImpactMetrics()
    }
    
    public func recordContribution(_ type: ContributionType) async {
        metrics.totalContributions += 1
        
        switch type {
        case .post:
            metrics.postsCreated += 1
        case .comment:
            metrics.commentsAdded += 1
        case .codeShared:
            metrics.codeSnippetsShared += 1
        case .helpProvided:
            metrics.helpfulResponses += 1
        }
        
        metrics.lastUpdated = Date()
    }
    
    public func recordLearning(topic: Topic, timeSpent: Int) async {
        metrics.learningHours += Double(timeSpent) / 60.0
        metrics.topicsLearned.insert(topic.rawValue)
    }
    
    public func getMetrics() async -> ImpactMetrics {
        metrics
    }
    
    public func calculateImpactScore() async -> Double {
        let contributionScore = Double(metrics.totalContributions) * 1.0
        let learningScore = metrics.learningHours * 2.0
        let helpScore = Double(metrics.helpfulResponses) * 3.0
        
        return contributionScore + learningScore + helpScore
    }
}

public struct ImpactMetrics: Codable, Sendable {
    public var totalContributions: Int = 0
    public var postsCreated: Int = 0
    public var commentsAdded: Int = 0
    public var codeSnippetsShared: Int = 0
    public var helpfulResponses: Int = 0
    public var learningHours: Double = 0.0
    public var topicsLearned: Set<String> = []
    public var lastUpdated: Date = Date()
    
    public init() {}
}

public enum ContributionType {
    case post
    case comment
    case codeShared
    case helpProvided
}
