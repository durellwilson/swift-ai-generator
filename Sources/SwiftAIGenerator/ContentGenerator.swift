import Foundation

public actor ContentGenerator {
    private var generationCount = 0
    private let templates: [ContentTemplate]
    
    public init() {
        self.templates = ContentTemplate.allTemplates
    }
    
    public func generate(topic: Topic) async throws -> GeneratedContent {
        generationCount += 1
        
        let template = templates.filter { $0.topic == topic }.randomElement() ?? templates[0]
        
        let content = GeneratedContent(
            id: UUID(),
            title: template.generateTitle(),
            body: template.generateBody(),
            codeSnippet: template.generateCode(),
            tags: template.tags,
            difficulty: template.difficulty,
            estimatedTime: template.estimatedTime,
            generatedAt: Date()
        )
        
        return content
    }
    
    public func generateBatch(count: Int, topics: [Topic]) async throws -> [GeneratedContent] {
        var results: [GeneratedContent] = []
        
        for _ in 0..<count {
            let topic = topics.randomElement() ?? .swiftUI
            let content = try await generate(topic: topic)
            results.append(content)
        }
        
        return results
    }
    
    public func getGenerationCount() async -> Int {
        generationCount
    }
}

public enum Topic: String, Codable, CaseIterable {
    case swiftUI = "SwiftUI"
    case swiftData = "SwiftData"
    case concurrency = "Concurrency"
    case testing = "Testing"
    case performance = "Performance"
    case security = "Security"
    case accessibility = "Accessibility"
    case animations = "Animations"
}

public struct GeneratedContent: Codable, Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let body: String
    public let codeSnippet: String
    public let tags: [String]
    public let difficulty: Difficulty
    public let estimatedTime: Int
    public let generatedAt: Date
    
    public init(id: UUID, title: String, body: String, codeSnippet: String, tags: [String], difficulty: Difficulty, estimatedTime: Int, generatedAt: Date) {
        self.id = id
        self.title = title
        self.body = body
        self.codeSnippet = codeSnippet
        self.tags = tags
        self.difficulty = difficulty
        self.estimatedTime = estimatedTime
        self.generatedAt = generatedAt
    }
}

public enum Difficulty: String, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct ContentTemplate {
    let topic: Topic
    let titleTemplates: [String]
    let bodyTemplates: [String]
    let codeTemplates: [String]
    let tags: [String]
    let difficulty: Difficulty
    let estimatedTime: Int
    
    func generateTitle() -> String {
        titleTemplates.randomElement() ?? "Swift Tutorial"
    }
    
    func generateBody() -> String {
        bodyTemplates.randomElement() ?? "Learn Swift concepts"
    }
    
    func generateCode() -> String {
        codeTemplates.randomElement() ?? "// Code example"
    }
    
    static let allTemplates: [ContentTemplate] = [
        ContentTemplate(
            topic: .swiftUI,
            titleTemplates: [
                "Master SwiftUI Animations",
                "Building Custom Views",
                "State Management Patterns",
                "Navigation Best Practices"
            ],
            bodyTemplates: [
                "Learn to create smooth, performant animations using SwiftUI's animation system. Master timing curves, spring animations, and transitions.",
                "Build reusable custom views with proper state management and composition. Follow SwiftUI best practices.",
                "Understand @State, @Binding, @Observable, and when to use each. Build scalable apps with proper data flow."
            ],
            codeTemplates: [
                "struct AnimatedView: View {\n    @State private var scale = 1.0\n    \n    var body: some View {\n        Circle()\n            .scaleEffect(scale)\n            .onTapGesture {\n                withAnimation(.spring) {\n                    scale = 2.0\n                }\n            }\n    }\n}",
                "@Observable\nfinal class ViewModel {\n    var items: [Item] = []\n    \n    func load() async {\n        items = await fetch()\n    }\n}"
            ],
            tags: ["SwiftUI", "Animation", "Views"],
            difficulty: .intermediate,
            estimatedTime: 30
        ),
        ContentTemplate(
            topic: .swiftData,
            titleTemplates: [
                "SwiftData Query Patterns",
                "CloudKit Sync with SwiftData",
                "Advanced Predicates",
                "Model Relationships"
            ],
            bodyTemplates: [
                "Master SwiftData queries with predicates, sorting, and filtering. Build efficient data layers.",
                "Sync your SwiftData models with CloudKit for multi-device support. Handle conflicts and migrations.",
                "Create complex relationships between models. Use cascading deletes and inverse relationships."
            ],
            codeTemplates: [
                "@Model\nfinal class Item {\n    var name: String\n    var createdAt: Date\n    var tags: [Tag]\n    \n    init(name: String) {\n        self.name = name\n        self.createdAt = Date()\n        self.tags = []\n    }\n}",
                "@Query(\n    filter: #Predicate<Item> { $0.createdAt > Date.now },\n    sort: \\.name\n)\nvar items: [Item]"
            ],
            tags: ["SwiftData", "Persistence", "CloudKit"],
            difficulty: .advanced,
            estimatedTime: 45
        ),
        ContentTemplate(
            topic: .concurrency,
            titleTemplates: [
                "Swift 6 Actor Patterns",
                "Async/Await Best Practices",
                "Task Groups and Cancellation",
                "MainActor Usage"
            ],
            bodyTemplates: [
                "Master Swift 6 actors for thread-safe code. Understand isolation and sendability.",
                "Write clean async code with proper error handling and cancellation support.",
                "Use task groups for parallel operations. Handle cancellation gracefully."
            ],
            codeTemplates: [
                "actor DataService {\n    private var cache: [String: Data] = [:]\n    \n    func fetch(_ key: String) async -> Data? {\n        if let cached = cache[key] {\n            return cached\n        }\n        let data = await download(key)\n        cache[key] = data\n        return data\n    }\n}",
                "@MainActor\nfinal class ViewModel: ObservableObject {\n    @Published var items: [Item] = []\n    \n    func load() async {\n        items = await service.fetch()\n    }\n}"
            ],
            tags: ["Concurrency", "Actors", "Swift6"],
            difficulty: .advanced,
            estimatedTime: 60
        ),
        ContentTemplate(
            topic: .testing,
            titleTemplates: [
                "Test-Driven Development in Swift",
                "Testing Async Code",
                "Mock Services and Protocols",
                "UI Testing with XCTest"
            ],
            bodyTemplates: [
                "Write tests first, then implement. Build reliable, maintainable code with TDD.",
                "Test async/await code with proper expectations and timeouts.",
                "Create mock services for isolated unit tests. Use protocols for testability."
            ],
            codeTemplates: [
                "final class ViewModelTests: XCTestCase {\n    func testLoad() async throws {\n        let vm = ViewModel(service: MockService())\n        await vm.load()\n        XCTAssertEqual(vm.items.count, 3)\n    }\n}",
                "protocol DataService {\n    func fetch() async -> [Item]\n}\n\nstruct MockService: DataService {\n    func fetch() async -> [Item] {\n        [Item(name: \"Test\")]\n    }\n}"
            ],
            tags: ["Testing", "TDD", "XCTest"],
            difficulty: .intermediate,
            estimatedTime: 40
        )
    ]
}
