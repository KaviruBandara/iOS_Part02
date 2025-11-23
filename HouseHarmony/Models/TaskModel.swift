//
//  TaskModel.swift
//  HouseHarmony
//
//  Individual task model with completion tracking
//

import Foundation

enum TaskPriority: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var points: Int {
        switch self {
        case .low: return 5
        case .medium: return 10
        case .high: return 20
        }
    }
}

enum TaskFrequency: String, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case oneTime = "One Time"
}

struct TaskModel: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var points: Int
    var category: String
    var priority: TaskPriority
    var frequency: TaskFrequency
    var isCompleted: Bool
    var completedBy: UUID? // User ID
    var completedAt: Date?
    var claimedBy: UUID? // User ID
    var claimedAt: Date?
    var dueDate: Date?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        points: Int = 10,
        category: String,
        priority: TaskPriority = .medium,
        frequency: TaskFrequency = .daily,
        isCompleted: Bool = false,
        completedBy: UUID? = nil,
        completedAt: Date? = nil,
        claimedBy: UUID? = nil,
        claimedAt: Date? = nil,
        dueDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.points = points
        self.category = category
        self.priority = priority
        self.frequency = frequency
        self.isCompleted = isCompleted
        self.completedBy = completedBy
        self.completedAt = completedAt
        self.claimedBy = claimedBy
        self.claimedAt = claimedAt
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
    
    var isClaimed: Bool {
        claimedBy != nil
    }
    
    var isAvailable: Bool {
        !isCompleted && !isClaimed
    }
    
    mutating func claim(by userId: UUID) {
        claimedBy = userId
        claimedAt = Date()
    }
    
    mutating func complete(by userId: UUID) {
        isCompleted = true
        completedBy = userId
        completedAt = Date()
    }
    
    mutating func unclaim() {
        claimedBy = nil
        claimedAt = nil
    }
    
    mutating func reset() {
        isCompleted = false
        completedBy = nil
        completedAt = nil
        claimedBy = nil
        claimedAt = nil
    }
}

// MARK: - Sample Data
extension TaskModel {
    static let samples: [TaskModel] = [
        TaskModel(
            title: "Wash dishes",
            description: "Clean all dishes from sink and dishwasher",
            points: 15,
            category: "Kitchen",
            priority: .medium
        ),
        TaskModel(
            title: "Vacuum living room",
            description: "Vacuum entire living room carpet",
            points: 20,
            category: "Living Room",
            priority: .high
        ),
        TaskModel(
            title: "Take out trash",
            description: "Empty all trash bins and take to outside bins",
            points: 5,
            category: "Kitchen",
            priority: .low
        ),
        TaskModel(
            title: "Clean bathroom",
            description: "Deep clean bathroom including toilet, shower, and sink",
            points: 25,
            category: "Bathroom",
            priority: .high
        ),
        TaskModel(
            title: "Water plants",
            description: "Water all indoor plants",
            points: 5,
            category: "Living Room",
            priority: .low
        )
    ]
}
