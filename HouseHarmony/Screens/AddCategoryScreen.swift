//
//  AddCategoryScreen.swift
//  HouseHarmony
//
//  Screen for adding new categories
//

import SwiftUI

struct AddCategoryScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var categoryName = ""
    @State private var selectedIcon = "house.fill"
    @State private var selectedColor = Color.accentCyan
    
    let availableIcons = [
        "house.fill", "fork.knife", "bed.double.fill", "toilet.fill",
        "shower.fill", "washer.fill", "car.fill", "leaf.fill",
        "trash.fill", "paintbrush.fill", "hammer.fill", "wrench.fill"
    ]
    
    let availableColors: [Color] = [
        .userRed, .accentOrange, .accentYellow, .accentGreen,
        .accentCyan, .userBlue, .accentPurple, .accentPink
    ]
    
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
                    
                    Text("Add Category")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveCategory()
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.accentGreen)
                    .buttonStyle(.plain)
                    .disabled(categoryName.isEmpty)
                    .opacity(categoryName.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 60)
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Preview
                        CategoryPreview(
                            name: categoryName.isEmpty ? "Category Name" : categoryName,
                            icon: selectedIcon,
                            color: selectedColor
                        )
                        
                        // Name Input
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Category Name")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            TextField("Enter category name", text: $categoryName)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.glassHeavy)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.glassBorder, lineWidth: 1.5)
                                )
                        }
                        
                        // Icon Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Select Icon")
                                .font(.system(size: 22, weight: .bold))
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
                                ForEach(availableIcons, id: \.self) { icon in
                                    IconButton(
                                        icon: icon,
                                        isSelected: selectedIcon == icon,
                                        color: selectedColor
                                    ) {
                                        selectedIcon = icon
                                    }
                                }
                            }
                        }
                        
                        // Color Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Select Color")
                                .font(.system(size: 22, weight: .bold))
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
                                ForEach(availableColors, id: \.self) { color in
                                    ColorButton(
                                        color: color,
                                        isSelected: selectedColor == color
                                    ) {
                                        selectedColor = color
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func saveCategory() {
        let newCategory = ChoreCategory(
            name: categoryName,
            icon: selectedIcon,
            colorHex: selectedColor.toHex() ?? "#4ECDC4",
            tasks: []
        )
        appState.choreCategories.append(newCategory)
        PersistenceService.shared.saveChoreCategories(appState.choreCategories)
        dismiss()
    }
}

// MARK: - Edit Category Screen
struct EditCategoryScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let category: ChoreCategory
    
    @State private var categoryName: String
    @State private var selectedIcon: String
    @State private var selectedColor: Color
    
    let availableIcons = [
        "house.fill", "fork.knife", "bed.double.fill", "toilet.fill",
        "shower.fill", "washer.fill", "car.fill", "leaf.fill",
        "trash.fill", "paintbrush.fill", "hammer.fill", "wrench.fill"
    ]
    
    let availableColors: [Color] = [
        .userRed, .accentOrange, .accentYellow, .accentGreen,
        .accentCyan, .userBlue, .accentPurple, .accentPink
    ]
    
    init(category: ChoreCategory) {
        self.category = category
        _categoryName = State(initialValue: category.name)
        _selectedIcon = State(initialValue: category.icon)
        _selectedColor = State(initialValue: category.color)
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
                    
                    Text("Edit Category")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveCategory()
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.accentGreen)
                    .buttonStyle(.plain)
                    .disabled(categoryName.isEmpty)
                    .opacity(categoryName.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 60)
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Preview
                        CategoryPreview(
                            name: categoryName.isEmpty ? "Category Name" : categoryName,
                            icon: selectedIcon,
                            color: selectedColor
                        )
                        
                        // Name Input
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Category Name")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            TextField("Enter category name", text: $categoryName)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.glassHeavy)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.glassBorder, lineWidth: 1.5)
                                )
                        }
                        
                        // Icon Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Select Icon")
                                .font(.system(size: 22, weight: .bold))
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
                                ForEach(availableIcons, id: \.self) { icon in
                                    IconButton(
                                        icon: icon,
                                        isSelected: selectedIcon == icon,
                                        color: selectedColor
                                    ) {
                                        selectedIcon = icon
                                    }
                                }
                            }
                        }
                        
                        // Color Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Select Color")
                                .font(.system(size: 22, weight: .bold))
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
                                ForEach(availableColors, id: \.self) { color in
                                    ColorButton(
                                        color: color,
                                        isSelected: selectedColor == color
                                    ) {
                                        selectedColor = color
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func saveCategory() {
        guard let index = appState.choreCategories.firstIndex(where: { $0.id == category.id }) else {
            return
        }
        
        // Update category
        appState.choreCategories[index].name = categoryName
        appState.choreCategories[index].icon = selectedIcon
        appState.choreCategories[index].colorHex = selectedColor.toHex() ?? "#4ECDC4"
        
        // Update all tasks in this category to reflect new category name
        for taskIndex in appState.choreCategories[index].tasks.indices {
            appState.choreCategories[index].tasks[taskIndex].category = categoryName
        }
        
        PersistenceService.shared.saveChoreCategories(appState.choreCategories)
        dismiss()
    }
}

// MARK: - Category Preview
struct CategoryPreview: View {
    let name: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.3), color.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 40,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(Color.glassHeavy)
                    .frame(width: 110, height: 110)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.5), lineWidth: 2)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(color)
            }
            
            Text(name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("0 tasks")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.2), color.opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
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

// MARK: - Icon Button
struct IconButton: View {
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(isSelected ? color : .white.opacity(0.7))
                .frame(width: 80, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? color.opacity(0.2) : Color.glassLight)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            isSelected ? color : (isFocused ? Color.white.opacity(0.5) : Color.glassBorder),
                            lineWidth: isSelected ? 2.5 : 1.5
                        )
                )
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Color Button
struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 60, height: 60)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isSelected ? color : (isFocused ? Color.white.opacity(0.5) : Color.glassBorder),
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Color Extension for Hex
extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        let r = Int(components[0] * 255.0)
        let g = Int(components[1] * 255.0)
        let b = Int(components[2] * 255.0)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

#Preview {
    AddCategoryScreen()
        .environmentObject(AppState())
}
