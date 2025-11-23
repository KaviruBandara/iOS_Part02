//
//  ChoresScreen.swift
//  HouseHarmony
//
//  Chore categories and tasks screen
//

import SwiftUI

struct ChoresScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: ChoreCategory?
    
    var body: some View {
        ZStack {
            if let category = selectedCategory {
                TaskListView(
                    category: category,
                    onBack: { selectedCategory = nil },
                    onTaskComplete: { task in
                        appState.completedTask = task
                        appState.showTaskCompletion = true
                    }
                )
            } else {
                CategoryGridView(onSelectCategory: { category in
                    selectedCategory = category
                })
            }
        }
        .animation(.smooth, value: selectedCategory)
        .onChange(of: appState.showTaskCompletion) { _, isShowing in
            if !isShowing {
                selectedCategory = nil
            }
        }
    }
}

// MARK: - Category Grid View
struct CategoryGridView: View {
    @EnvironmentObject var appState: AppState
    let onSelectCategory: (ChoreCategory) -> Void
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                // Header - Ultra Compact
                HStack(spacing: 10) {
                    Image("HouseHarmony")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("Choose a Category")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(.top, 10)
                
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 25),
                            GridItem(.flexible(), spacing: 25),
                            GridItem(.flexible(), spacing: 25)
                        ],
                        spacing: 25
                    ) {
                        ForEach(appState.choreCategories) { category in
                            CategoryCard(category: category) {
                                onSelectCategory(category)
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: ChoreCategory
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 18) {
                // Icon with glow
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [category.color.opacity(0.3), category.color.opacity(0.1), Color.clear],
                                center: .center,
                                startRadius: 30,
                                endRadius: 70
                            )
                        )
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .fill(Color.glassHeavy)
                        .frame(width: 110, height: 110)
                        .overlay(
                            Circle()
                                .stroke(category.color.opacity(0.5), lineWidth: 2)
                        )
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 48))
                        .foregroundColor(category.color)
                }
                
                // Category Info
                VStack(spacing: 6) {
                    Text(category.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("\(category.tasks.count) tasks")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                    
                    // Progress
                    if category.totalTasksCount > 0 {
                        VStack(spacing: 6) {
                            // Progress bar
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 6)
                                    
                                    Capsule()
                                        .fill(category.color)
                                        .frame(width: geo.size.width * category.completionPercentage, height: 6)
                                }
                            }
                            .frame(height: 6)
                            .frame(maxWidth: 180)
                            
                            Text("\(Int(category.completionPercentage * 100))%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(category.color)
                                .lineLimit(1)
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .frame(height: 340)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.glassHeavy)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        category.color.opacity(isFocused ? 0.35 : 0.2),
                                        category.color.opacity(isFocused ? 0.15 : 0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        isFocused ? category.color.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? category.color.opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 30 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Task List View
struct TaskListView: View {
    @EnvironmentObject var appState: AppState
    let category: ChoreCategory
    let onBack: () -> Void
    let onTaskComplete: (TaskModel) -> Void
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
            // Header
            HStack {
                BackButton {
                    onBack()
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    Image(systemName: category.icon)
                        .font(.system(size: 40))
                        .foregroundColor(category.color)
                    
                    Text(category.name)
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("\(category.completedTasksCount)/\(category.totalTasksCount)")
                    .font(.title2)
                    .foregroundColor(category.color)
            }
            .padding(.horizontal, 60)
            
            // Tasks
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(category.tasks) { task in
                        TaskCard(
                            task: task,
                            categoryColor: category.color,
                            onClaim: {
                                if let categoryIndex = appState.choreCategories.firstIndex(where: { $0.id == category.id }) {
                                    appState.claimTask(task, in: appState.choreCategories[categoryIndex].id)
                                }
                            },
                            onComplete: {
                                if let categoryIndex = appState.choreCategories.firstIndex(where: { $0.id == category.id }) {
                                    appState.completeTask(task, in: appState.choreCategories[categoryIndex].id)
                                    onTaskComplete(task)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            }
        }
    }
}

#Preview {
    ChoresScreen()
        .environmentObject(AppState())
}
