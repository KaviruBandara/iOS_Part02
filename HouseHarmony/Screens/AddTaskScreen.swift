//
//  AddTaskScreen.swift
//  HouseHarmony
//
//  Screen for adding new tasks
//

import SwiftUI

struct AddTaskScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var taskPoints = 10
    @State private var selectedCategory: ChoreCategory?
    @State private var selectedPriority: TaskPriority = .medium
    @State private var selectedFrequency: TaskFrequency = .daily
    @State private var assignedUser: UserModel?
    
    var body: some View {
        ZStack {
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text("Add Task")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveTask()
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.accentGreen)
                    .buttonStyle(.plain)
                    .disabled(taskTitle.isEmpty || selectedCategory == nil)
                    .opacity((taskTitle.isEmpty || selectedCategory == nil) ? 0.5 : 1.0)
                }
                .padding(.horizontal, 60)
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Task Info
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Task Information")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Title
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Title")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                TextField("Enter task title", text: $taskTitle)
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .padding(18)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.glassHeavy)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.glassBorder, lineWidth: 1.5)
                                    )
                            }
                            
                            // Description
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Description (Optional)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                TextField("Enter task description", text: $taskDescription)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(18)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.glassHeavy)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.glassBorder, lineWidth: 1.5)
                                    )
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                        
                        // Points
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Points")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.accentYellow)
                                    Text("\(taskPoints)")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            HStack(spacing: 15) {
                                ForEach([5, 10, 15, 20, 25, 30], id: \.self) { points in
                                    PointButton(points: points, isSelected: taskPoints == points) {
                                        taskPoints = points
                                    }
                                }
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                        
                        // Category Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Category")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ],
                                spacing: 15
                            ) {
                                ForEach(appState.choreCategories) { category in
                                    CategorySelectButton(
                                        category: category,
                                        isSelected: selectedCategory?.id == category.id
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                        
                        // Priority & Frequency
                        HStack(spacing: 20) {
                            // Priority
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Priority")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 10) {
                                    ForEach([TaskPriority.high, .medium, .low], id: \.self) { priority in
                                        PriorityButton(
                                            priority: priority,
                                            isSelected: selectedPriority == priority
                                        ) {
                                            selectedPriority = priority
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.glassHeavy)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.glassBorder, lineWidth: 1.5)
                            )
                            
                            // Frequency
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Frequency")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 10) {
                                    ForEach([TaskFrequency.daily, .weekly, .monthly], id: \.self) { frequency in
                                        FrequencyButton(
                                            frequency: frequency,
                                            isSelected: selectedFrequency == frequency
                                        ) {
                                            selectedFrequency = frequency
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.glassHeavy)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.glassBorder, lineWidth: 1.5)
                            )
                        }
                        
                        // Assign to User (Optional)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Assign to User (Optional)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ],
                                spacing: 15
                            ) {
                                // None option
                                UserSelectButton(
                                    user: nil,
                                    isSelected: assignedUser == nil
                                ) {
                                    assignedUser = nil
                                }
                                
                                ForEach(appState.users) { user in
                                    UserSelectButton(
                                        user: user,
                                        isSelected: assignedUser?.id == user.id
                                    ) {
                                        assignedUser = user
                                    }
                                }
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func saveTask() {
        guard let category = selectedCategory,
              let categoryIndex = appState.choreCategories.firstIndex(where: { $0.id == category.id }) else {
            return
        }
        
        let newTask = TaskModel(
            title: taskTitle,
            description: taskDescription,
            points: taskPoints,
            category: category.name,
            priority: selectedPriority,
            frequency: selectedFrequency,
            claimedBy: assignedUser?.id,
            claimedAt: assignedUser != nil ? Date() : nil
        )
        
        appState.choreCategories[categoryIndex].tasks.append(newTask)
        PersistenceService.shared.saveChoreCategories(appState.choreCategories)
        dismiss()
    }
}

// MARK: - Point Button
struct PointButton: View {
    let points: Int
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            Text("\(points)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .frame(width: 70, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.accentYellow.opacity(0.3) : Color.glassLight)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? Color.accentYellow : (isFocused ? Color.white.opacity(0.5) : Color.glassBorder),
                            lineWidth: isSelected ? 2.5 : 1.5
                        )
                )
                .scaleEffect(isFocused ? 1.05 : 1.0)
        }
        .buttonStyle(.card)
    }
}

// MARK: - Category Select Button
struct CategorySelectButton: View {
    let category: ChoreCategory
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 32))
                    .foregroundColor(category.color)
                
                Text(category.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? category.color.opacity(0.2) : Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isSelected ? category.color : (isFocused ? Color.white.opacity(0.5) : Color.glassBorder),
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Priority Button
struct PriorityButton: View {
    let priority: TaskPriority
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    private var priorityColor: Color {
        switch priority {
        case .high: return .userRed
        case .medium: return .accentOrange
        case .low: return .accentGreen
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(priority.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(priorityColor)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? priorityColor.opacity(0.2) : Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? priorityColor : (isFocused ? Color.white.opacity(0.5) : Color.glassBorder),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Frequency Button
struct FrequencyButton: View {
    let frequency: TaskFrequency
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(frequency.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentCyan)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentCyan.opacity(0.2) : Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.accentCyan : (isFocused ? Color.white.opacity(0.5) : Color.glassBorder),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - User Select Button
struct UserSelectButton: View {
    let user: UserModel?
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if let user = user {
                    ZStack {
                        Circle()
                            .fill(user.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(user.avatar)
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipped()
                            .clipShape(Circle())
                    }
                    Text(user.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                } else {
                    Image(systemName: "person.slash.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.5))
                    Text("None")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? (user?.color.opacity(0.2) ?? Color.white.opacity(0.1)) : Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isSelected ? (user?.color ?? Color.white) : (isFocused ? Color.white.opacity(0.5) : Color.glassBorder),
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Edit Task Screen
struct EditTaskScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let task: TaskModel
    let category: ChoreCategory
    
    @State private var taskTitle: String
    @State private var taskDescription: String
    @State private var taskPoints: Int
    @State private var selectedCategory: ChoreCategory?
    @State private var selectedPriority: TaskPriority
    @State private var selectedFrequency: TaskFrequency
    @State private var assignedUser: UserModel?
    
    init(task: TaskModel, category: ChoreCategory) {
        self.task = task
        self.category = category
        _taskTitle = State(initialValue: task.title)
        _taskDescription = State(initialValue: task.description)
        _taskPoints = State(initialValue: task.points)
        _selectedCategory = State(initialValue: category)
        _selectedPriority = State(initialValue: task.priority)
        _selectedFrequency = State(initialValue: task.frequency)
        // Find assigned user if any
        if let claimedBy = task.claimedBy {
            _assignedUser = State(initialValue: AppState().users.first { $0.id == claimedBy })
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text("Edit Task")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveTask()
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.accentGreen)
                    .buttonStyle(.plain)
                    .disabled(taskTitle.isEmpty || selectedCategory == nil)
                    .opacity((taskTitle.isEmpty || selectedCategory == nil) ? 0.5 : 1.0)
                }
                .padding(.horizontal, 60)
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Task Info
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Task Information")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Title
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Title")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                TextField("Enter task title", text: $taskTitle)
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .padding(18)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.glassHeavy)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.glassBorder, lineWidth: 1.5)
                                    )
                            }
                            
                            // Description
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Description (Optional)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                TextField("Enter task description", text: $taskDescription)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(18)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.glassHeavy)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.glassBorder, lineWidth: 1.5)
                                    )
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                        
                        // Points
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Points")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.accentYellow)
                                    Text("\(taskPoints)")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            HStack(spacing: 15) {
                                ForEach([5, 10, 15, 20, 25, 30], id: \.self) { points in
                                    PointButton(points: points, isSelected: taskPoints == points) {
                                        taskPoints = points
                                    }
                                }
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                        
                        // Category Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Category")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ],
                                spacing: 15
                            ) {
                                ForEach(appState.choreCategories) { category in
                                    CategorySelectButton(
                                        category: category,
                                        isSelected: selectedCategory?.id == category.id
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                        
                        // Priority & Frequency
                        HStack(spacing: 20) {
                            // Priority
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Priority")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 10) {
                                    ForEach([TaskPriority.high, .medium, .low], id: \.self) { priority in
                                        PriorityButton(
                                            priority: priority,
                                            isSelected: selectedPriority == priority
                                        ) {
                                            selectedPriority = priority
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.glassHeavy)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.glassBorder, lineWidth: 1.5)
                            )
                            
                            // Frequency
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Frequency")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 10) {
                                    ForEach([TaskFrequency.daily, .weekly, .monthly], id: \.self) { frequency in
                                        FrequencyButton(
                                            frequency: frequency,
                                            isSelected: selectedFrequency == frequency
                                        ) {
                                            selectedFrequency = frequency
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.glassHeavy)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.glassBorder, lineWidth: 1.5)
                            )
                        }
                        
                        // Assign to User (Optional)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Assign to User (Optional)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ],
                                spacing: 15
                            ) {
                                // None option
                                UserSelectButton(
                                    user: nil,
                                    isSelected: assignedUser == nil
                                ) {
                                    assignedUser = nil
                                }
                                
                                ForEach(appState.users) { user in
                                    UserSelectButton(
                                        user: user,
                                        isSelected: assignedUser?.id == user.id
                                    ) {
                                        assignedUser = user
                                    }
                                }
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func saveTask() {
        guard let newCategory = selectedCategory else { return }
        
        // Find old category index
        guard let oldCategoryIndex = appState.choreCategories.firstIndex(where: { $0.id == category.id }) else {
            return
        }
        
        // Remove task from old category
        appState.choreCategories[oldCategoryIndex].tasks.removeAll { $0.id == task.id }
        
        // Find new category index (might be same as old)
        guard let newCategoryIndex = appState.choreCategories.firstIndex(where: { $0.id == newCategory.id }) else {
            return
        }
        
        // Create updated task
        var updatedTask = task
        updatedTask.title = taskTitle
        updatedTask.description = taskDescription
        updatedTask.points = taskPoints
        updatedTask.category = newCategory.name
        updatedTask.priority = selectedPriority
        updatedTask.frequency = selectedFrequency
        updatedTask.claimedBy = assignedUser?.id
        updatedTask.claimedAt = assignedUser != nil ? Date() : nil
        
        // Add to new category
        appState.choreCategories[newCategoryIndex].tasks.append(updatedTask)
        
        PersistenceService.shared.saveChoreCategories(appState.choreCategories)
        dismiss()
    }
}

#Preview {
    AddTaskScreen()
        .environmentObject(AppState())
}
