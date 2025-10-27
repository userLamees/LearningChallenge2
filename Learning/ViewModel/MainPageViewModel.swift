//
//  MainPageViewModel.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

// MainPageViewModel.swift
// MainPageView.swift
// MainPageViewModel.swift
import Foundation
internal import Combine

class MainPageViewModel: ObservableObject {
    @Published var currentStatus: LearningStatus
    @Published var currentWeek: [Date] = []
    @Published var selectedDate: Date = Date()
    @Published var isGoalCompleted: Bool = false
    
    @Published var calendar: Calendar = .current
    
    init(subject: String, duration: LearningDuration) {
        self.currentStatus = LearningStatus(subject: subject, duration: duration)
        self.currentWeek = []
        self.selectedDate = Date()
        updateWeek(for: Date())
    }
    
    func updateGoal(newSubject: String, newDuration: LearningDuration) {
        // 1. تحديث الموضوع والمدة في الحالة الحالية
        currentStatus.subject = newSubject
        currentStatus.duration = newDuration
        currentStatus.daysLearned = 0
        currentStatus.daysFreezed = 0
        
    }
    
    func selectedDateStatus(for date: Date) -> LogType {
        let dayStart = calendar.startOfDay(for: date)
        
        return currentStatus.loggedStatus.first { calendar.isDate($0.key, inSameDayAs: dayStart) }?.value ?? .none
    }
    
    var totalDaysRequired: Int {
        return currentStatus.duration.daysCount
    }
    
    func checkGoalCompletion() {
        if currentStatus.daysLearned >= totalDaysRequired {
            isGoalCompleted = true
        } else {
            isGoalCompleted = false
        }
    }
    
    func resetGoalSame() {
        let subject = currentStatus.subject
        let duration = currentStatus.duration
        
        currentStatus = LearningStatus(subject: subject, duration: duration)
        isGoalCompleted = false
    }
    
    // --- A. منطق التاريخ والتنقل ---
    
    func updateWeek(for date: Date) {
        let today = calendar.startOfDay(for: date)
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else { return }
        
        currentWeek = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
    }
    
    func navigateWeek(by value: Int) {
        guard let newDate = calendar.date(byAdding: .weekOfYear, value: value, to: selectedDate) else { return }
        selectedDate = newDate
        updateWeek(for: newDate)
    }
    

    func canLog(for date: Date) -> Bool {
        let selectedDay = calendar.startOfDay(for: date)
        

        // 2. لا يمكن التسجيل لليوم إذا كان مسجلاً مسبقاً.
        guard selectedDateStatus(for: date) == .none else {
            return false
        }
        
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: selectedDay) else {
            return true
        }
        
        let yesterdayStatus = selectedDateStatus(for: yesterday)
        
        if yesterdayStatus == .none {
            return currentStatus.loggedStatus.isEmpty
        }
        
        // إذا كان يوم أمس مسجلاً، يمكن التسجيل لليوم المحدد (سواء كان ماضياً أو مستقبلاً).
        return true
    }    // --- B. منطق القيود اليومية والتجميد ---
    
    var freezesRemaining: Int {
        return currentStatus.duration.maxFreezes - currentStatus.freezesUsed
    }
    
    var hasInteractedToday: Bool {
        guard let lastDate = currentStatus.lastInteractionDate else {
            return false
        }
        return Calendar.current.isDateInToday(lastDate)
    }
    
    var isLearnButtonEnabled: Bool {
        guard canLog(for: selectedDate) else { return false }
        let totalDays = currentStatus.duration.daysCount
        return currentStatus.daysLearned < totalDays
    }
    
    var isFreezeButtonEnabled: Bool {
        guard canLog(for: selectedDate) else { return false }
        return freezesRemaining > 0
    }
    
    func logAsLearned() {
        guard isLearnButtonEnabled else { return }
        
        currentStatus.daysLearned += 1
        currentStatus.lastInteractionDate = Date()
        currentStatus.loggedStatus[calendar.startOfDay(for: selectedDate)] = .learned
        print("Logged as Learned for date: \(selectedDate). Total days: \(currentStatus.daysLearned)")
        checkGoalCompletion()
    }
    
    func logAsFreezed() {
        guard isFreezeButtonEnabled else { return }
        
        currentStatus.freezesUsed += 1
        currentStatus.daysFreezed += 1
        currentStatus.lastInteractionDate = Date()
        currentStatus.loggedStatus[calendar.startOfDay(for: selectedDate)] = .freezed
        print("Logged as Freezed for date: \(selectedDate). Freezes left: \(freezesRemaining)")
    }
    func getDates(for month: Date) -> [Date] {
        // نستخدم viewModel.calendar للحصول على المدى
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }
        let numDays = range.count
        
        let components = calendar.dateComponents([.year, .month], from: month)
        
        var dates: [Date] = []
        for day in 1...numDays {
            var dateComponents = components
            dateComponents.day = day
            if let date = calendar.date(from: dateComponents) {
                dates.append(date)
            }
        }
        return dates
    }
}
