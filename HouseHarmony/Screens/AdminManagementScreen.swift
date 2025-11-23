//
//  AdminManagementScreen.swift
//  HouseHarmony
//
//  Admin panel for managing categories and tasks
//

import SwiftUI

struct AdminManagementScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showAddCategory = false
    @State private var showAddTask = false
    @State private var selectedCategory: ChoreCategory?
    @State private var selectedTask: TaskModel?
    @State private var selectedTaskCategory: ChoreCategory?
    @State private var showDeleteCategoryAlert = false
    @State private var categoryToDelete: ChoreCategory?
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                // Header - Ultra Compact
                HStack(spacing: 12) {
                    BackButton {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Image("HouseHarmony")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("Admin Panel")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.horizontal, 60)
                .padding(.top, 10)
                
                // Admin Options
                ScrollView {
                    VStack(spacing: 20) {
                        // Category Management
                        AdminSection(title: "Category Management", icon: "folder.fill", color: .accentCyan) {
                            VStack(spacing: 15) {
                                AdminButton(
                                    title: "Add New Category",
                                    icon: "plus.circle.fill",
                                    color: .accentGreen
                                ) {
                                    showAddCategory = true
                                }
                                
                                ForEach(appState.choreCategories) { category in
                                    HStack(spacing: 10) {
                                        AdminButton(
                                            title: "Edit \(category.name)",
                                            icon: "pencil.circle.fill",
                                            color: category.color
                                        ) {
                                            selectedCategory = category
                                        }
                                        
                                        Button {
                                            categoryToDelete = category
                                            showDeleteCategoryAlert = true
                                        } label: {
                                            Image(systemName: "trash.circle.fill")
                                                .font(.system(size: 28))
                                                .foregroundColor(.userRed)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        
                        // Task Management
                        AdminSection(title: "Task Management", icon: "checklist", color: .accentOrange) {
                            VStack(spacing: 15) {
                                AdminButton(
                                    title: "Add New Task",
                                    icon: "plus.circle.fill",
                                    color: .accentGreen
                                ) {
                                    showAddTask = true
                                }
                                
                                ForEach(appState.choreCategories) { category in
                                    if !category.tasks.isEmpty {
                                        Text(category.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(category.color)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.top, 10)
                                        
                                        ForEach(category.tasks) { task in
                                            TaskManagementRow(
                                                task: task,
                                                category: category,
                                                onEdit: {
                                                    selectedTask = task
                                                    selectedTaskCategory = category
                                                },
                                                onDelete: {
                                                    deleteTask(task, from: category)
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showAddCategory) {
            AddCategoryScreen()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskScreen()
                .environmentObject(appState)
        }
        .sheet(item: $selectedCategory) { category in
            EditCategoryScreen(category: category)
                .environmentObject(appState)
        }
        .sheet(item: $selectedTask) { task in
            if let category = selectedTaskCategory {
                EditTaskScreen(task: task, category: category)
                    .environmentObject(appState)
            }
        }
        .alert("Delete Category", isPresented: $showDeleteCategoryAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    deleteCategory(category)
                }
            }
        } message: {
            if let category = categoryToDelete {
                Text("Are you sure you want to delete '\(category.name)' and all its tasks? This cannot be undone.")
            }
        }
    }
    
    private func deleteCategory(_ category: ChoreCategory) {
        appState.choreCategories.removeAll { $0.id == category.id }
        PersistenceService.shared.saveChoreCategories(appState.choreCategories)
    }
    
    private func deleteTask(_ task: TaskModel, from category: ChoreCategory) {
        guard let categoryIndex = appState.choreCategories.firstIndex(where: { $0.id == category.id }) else {
            return
        }
        appState.choreCategories[categoryIndex].tasks.removeAll { $0.id == task.id }
        PersistenceService.shared.saveChoreCategories(appState.choreCategories)
    }
}

// MARK: - Admin Section
struct AdminSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            
            content
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.15), color.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.glassBorder, lineWidth: 1.5)
        )
    }
}

// MARK: - Admin Button
struct AdminButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.glassLight)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        color.opacity(isFocused ? 0.25 : 0.15),
                                        color.opacity(isFocused ? 0.12 : 0.05)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isFocused ? color.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 2.5 : 1
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(
                color: isFocused ? color.opacity(0.4) : Color.black.opacity(0.2),
                radius: isFocused ? 20 : 10
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Task Management Row
struct TaskManagementRow: View {
    let task: TaskModel
    let category: ChoreCategory
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                        Text("\(task.points)")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.accentYellow)
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(task.priority.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                        .foregroundColor(.accentCyan)
                }
                .buttonStyle(.plain)
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.userRed)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.glassLight)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isFocused ? category.color.opacity(0.6) : Color.clear,
                    lineWidth: 1.5
                )
        )
    }
}

#Preview {
    AdminManagementScreen()
        .environmentObject(AppState())
}
