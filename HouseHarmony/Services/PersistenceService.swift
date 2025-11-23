//
//  PersistenceService.swift
//  HouseHarmony
//
//  Local data persistence using UserDefaults and JSON
//

import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let users = "hh_users"
        static let choreCategories = "hh_chore_categories"
        static let lastResetDate = "hh_last_reset_date"
        static let houseSession = "hh_house_session"
    }
    
    private init() {}
    
    // MARK: - Users
    func saveUsers(_ users: [UserModel]) {
        if let encoded = try? JSONEncoder().encode(users) {
            userDefaults.set(encoded, forKey: Keys.users)
        }
    }
    
    func loadUsers() -> [UserModel] {
        guard let data = userDefaults.data(forKey: Keys.users),
              let users = try? JSONDecoder().decode([UserModel].self, from: data) else {
            return []
        }
        return users
    }
    
    // MARK: - Chore Categories
    func saveChoreCategories(_ categories: [ChoreCategory]) {
        if let encoded = try? JSONEncoder().encode(categories) {
            userDefaults.set(encoded, forKey: Keys.choreCategories)
        }
    }
    
    func loadChoreCategories() -> [ChoreCategory] {
        guard let data = userDefaults.data(forKey: Keys.choreCategories),
              let categories = try? JSONDecoder().decode([ChoreCategory].self, from: data) else {
            return []
        }
        return categories
    }
    
    // MARK: - Daily Reset
    func checkAndPerformDailyReset() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastReset = userDefaults.object(forKey: Keys.lastResetDate) as? Date {
            let lastResetDay = calendar.startOfDay(for: lastReset)
            
            if today > lastResetDay {
                performDailyReset()
                userDefaults.set(today, forKey: Keys.lastResetDate)
                return true
            }
        } else {
            userDefaults.set(today, forKey: Keys.lastResetDate)
        }
        
        return false
    }
    
    private func performDailyReset() {
        var categories = loadChoreCategories()
        
        // Reset daily tasks
        for categoryIndex in categories.indices {
            for taskIndex in categories[categoryIndex].tasks.indices {
                if categories[categoryIndex].tasks[taskIndex].frequency == .daily {
                    categories[categoryIndex].tasks[taskIndex].reset()
                }
            }
        }
        
        saveChoreCategories(categories)
    }
    
    // MARK: - House Session
    func saveHouseSession(_ session: HouseSession) {
        if let encoded = try? JSONEncoder().encode(session) {
            userDefaults.set(encoded, forKey: Keys.houseSession)
        }
    }
    
    func loadHouseSession() -> HouseSession {
        guard let data = userDefaults.data(forKey: Keys.houseSession),
              let session = try? JSONDecoder().decode(HouseSession.self, from: data) else {
            return HouseSession()
        }
        return session
    }
    
    // MARK: - Clear All Data
    func clearAllData() {
        userDefaults.removeObject(forKey: Keys.users)
        userDefaults.removeObject(forKey: Keys.choreCategories)
        userDefaults.removeObject(forKey: Keys.lastResetDate)
        userDefaults.removeObject(forKey: Keys.houseSession)
    }
    
    // MARK: - Reset to Defaults
    func resetToDefaults() {
        clearAllData()
        saveUsers(UserModel.samples)
        saveChoreCategories(ChoreCategory.samples)
    }
}
