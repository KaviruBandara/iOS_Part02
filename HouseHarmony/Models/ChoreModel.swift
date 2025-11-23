//
//  ChoreModel.swift
//  HouseHarmony
//
//  Chore category model (e.g., Kitchen, Bathroom, Living Room)
//

import Foundation
import SwiftUI

struct ChoreCategory: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var icon: String // SF Symbol name
    var colorHex: String
    var tasks: [TaskModel]
    
    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var totalTasksCount: Int {
        tasks.count
    }
    
    var completionPercentage: Double {
        guard totalTasksCount > 0 else { return 0 }
        return Double(completedTasksCount) / Double(totalTasksCount)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        colorHex: String,
        tasks: [TaskModel] = []
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.tasks = tasks
    }
}

// MARK: - Sample Data
extension ChoreCategory {
    static let samples: [ChoreCategory] = [
        ChoreCategory(
            name: "Kitchen",
            icon: "fork.knife",
            colorHex: "#FF6B6B",
            tasks: [
                TaskModel(title: "Wash dishes", points: 15, category: "Kitchen"),
                TaskModel(title: "Clean countertops", points: 10, category: "Kitchen"),
                TaskModel(title: "Empty trash", points: 5, category: "Kitchen"),
                TaskModel(title: "Organize fridge", points: 20, category: "Kitchen"),
                TaskModel(title: "Sweep floor", points: 10, category: "Kitchen"),
                TaskModel(title: "Clean stove", points: 15, category: "Kitchen")
            ]
        ),
        ChoreCategory(
            name: "Bathroom",
            icon: "shower.fill",
            colorHex: "#4ECDC4",
            tasks: [
                TaskModel(title: "Clean toilet", points: 20, category: "Bathroom"),
                TaskModel(title: "Clean shower", points: 20, category: "Bathroom"),
                TaskModel(title: "Clean sink", points: 10, category: "Bathroom"),
                TaskModel(title: "Restock supplies", points: 5, category: "Bathroom"),
                TaskModel(title: "Mop floor", points: 15, category: "Bathroom")
            ]
        ),
        ChoreCategory(
            name: "Living Room",
            icon: "sofa.fill",
            colorHex: "#FFD93D",
            tasks: [
                TaskModel(title: "Vacuum carpet", points: 15, category: "Living Room"),
                TaskModel(title: "Dust surfaces", points: 10, category: "Living Room"),
                TaskModel(title: "Organize cushions", points: 5, category: "Living Room"),
                TaskModel(title: "Clean windows", points: 20, category: "Living Room"),
                TaskModel(title: "Water plants", points: 5, category: "Living Room")
            ]
        ),
        ChoreCategory(
            name: "Bedroom",
            icon: "bed.double.fill",
            colorHex: "#A8E6CF",
            tasks: [
                TaskModel(title: "Make bed", points: 5, category: "Bedroom"),
                TaskModel(title: "Change sheets", points: 15, category: "Bedroom"),
                TaskModel(title: "Organize closet", points: 20, category: "Bedroom"),
                TaskModel(title: "Vacuum floor", points: 10, category: "Bedroom"),
                TaskModel(title: "Dust furniture", points: 10, category: "Bedroom")
            ]
        ),
        ChoreCategory(
            name: "Laundry",
            icon: "washer.fill",
            colorHex: "#95E1D3",
            tasks: [
                TaskModel(title: "Wash clothes", points: 15, category: "Laundry"),
                TaskModel(title: "Dry clothes", points: 10, category: "Laundry"),
                TaskModel(title: "Fold laundry", points: 15, category: "Laundry"),
                TaskModel(title: "Iron clothes", points: 20, category: "Laundry"),
                TaskModel(title: "Put away clothes", points: 10, category: "Laundry")
            ]
        ),
        ChoreCategory(
            name: "Outdoor",
            icon: "leaf.fill",
            colorHex: "#F38181",
            tasks: [
                TaskModel(title: "Mow lawn", points: 30, category: "Outdoor"),
                TaskModel(title: "Water garden", points: 10, category: "Outdoor"),
                TaskModel(title: "Take out bins", points: 5, category: "Outdoor"),
                TaskModel(title: "Clean patio", points: 15, category: "Outdoor"),
                TaskModel(title: "Trim bushes", points: 25, category: "Outdoor")
            ]
        )
    ]
}
