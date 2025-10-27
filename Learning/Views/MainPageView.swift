//
//  MainPageView.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//
// MainPageView.swift
import SwiftUI
import Foundation

struct MainPageView: View {
    
    @StateObject var viewModel: MainPageViewModel
    @State private var showingDatePickerSheet = false // لفتح شاشة اختيار التاريخ
    @State private var showingUpdateSettingsSheet = false
    @State private var showingAllActivitiesSheet: Bool = false
    let primaryColor = Color.orange
    let unselectedDarkColor = Color(red: 0.1, green: 0.1, blue: 0.1)
    
    
    let learnedColor = Color(red: 105/255, green: 75/255, blue: 55/255) // خلفية Days Learned
    let freezedColor = Color(red: 45/255, green: 80/255, blue: 95/255) // خلفية Day Freezed
    
    let lightBlueColor = Color(red: 135/255, green: 206/255, blue: 250/255)
    
    init(subject: String, duration: LearningDuration) {
        _viewModel = StateObject(wrappedValue: MainPageViewModel(subject: subject, duration: duration))
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                
                ActivityHeaderView()
                
                if viewModel.isGoalCompleted {
                    // شاشة اكتمال الهدف
                    GoalCompletedView(
                        viewModel:viewModel,
                        showingUpdateSettingsSheet: $showingUpdateSettingsSheet)
                } else {
                    
                    VStack(spacing: 15){
                        
                        CalendarNavigationHeader() // المكونات الآن موجودة هنا فقط
                        WeekView(viewModel: viewModel)
                        LearningStatusCards()
                        
                    } // نهاية VStack الخلفية المستديرة
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                    .background(Color.black.opacity(3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.4)
                                    , lineWidth: 2) // 💡 يمكنك تعديل شدة اللون الرمادي (opacity) وسمك الخط (lineWidth) هنا
                    )
                    .cornerRadius(25)
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    BigActionButtons()
                }
                
            }
            
        }.onAppear {
            viewModel.updateWeek(for: Date())
        }
        .toolbar(.hidden, for: .navigationBar)
        
        // 1. Sheet لاختيار التاريخ (Month Year Picker)
        .sheet(isPresented: $showingAllActivitiesSheet) {
            
            AllActivitiesView(viewModel: viewModel)
//            .presentationDetents([.fraction(0.5)])
//            .presentationBackground(.ultraThinMaterial)
        }
        
    .sheet(isPresented: $showingUpdateSettingsSheet) {
            UpdateGoalSettingsView(
                initialSubject: viewModel.currentStatus.subject,
                initialDuration: viewModel.currentStatus.duration,
                onGoalUpdate: { newSubject, newDuration in
                    viewModel.updateGoal(newSubject: newSubject, newDuration: newDuration)
                }
            )
            .toolbar(.hidden, for: .navigationBar)
        }
    .sheet(isPresented: $showingDatePickerSheet) {
            MonthYearPickerView(selectedDate: $viewModel.selectedDate)
            .presentationDetents([.fraction(0.5)])
            .presentationBackground(.ultraThinMaterial)
        }
    }
    
  
    
    @ViewBuilder
    func ActivityHeaderView() -> some View {
        HStack {
            Text("Activity").font(.largeTitle).fontWeight(.bold)
            Spacer()
            HStack(spacing: 15) {
                Button(action: { showingAllActivitiesSheet = true }) { // زر التقويم
                    Image(systemName: "calendar")
                        .foregroundColor(.white).font(.title2).padding(10)
                        .background(Circle().fill(unselectedDarkColor).shadow(radius: 5))
                }
                // 🚨 زر الشخص (Profile Icon) - يفتح شاشة إدارة الهدف 🚨
                Button(action: { showingUpdateSettingsSheet = true }) {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.white).font(.title2).padding(10)
                        .background(Circle().fill(unselectedDarkColor).shadow(radius: 5))
                }
            }
        }
    }
    
    @ViewBuilder
    func CalendarNavigationHeader() -> some View {
        HStack {
            Button(action: { showingDatePickerSheet = true }) {
                HStack {
                    Text("\(viewModel.selectedDate, formatter: DateFormatter.monthAndYear)").font(.headline).foregroundColor(.white)
                    Image(systemName: "chevron.down").foregroundColor(.white)
                }
            }
            Spacer()
            Button { viewModel.navigateWeek(by: -1) } label: { Image(systemName: "chevron.left").foregroundColor(.gray) }
                .padding(.trailing, 10)
            Button { viewModel.navigateWeek(by: 1) } label: { Image(systemName: "chevron.right").foregroundColor(.gray) }
        }
    }
    
    @ViewBuilder
    func WeekView(viewModel: MainPageViewModel) -> some View {
        let dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        
        HStack {
            ForEach(0..<viewModel.currentWeek.count, id: \.self) { index in
                let date = viewModel.currentWeek[index]
                let dayComponent = Calendar.current.component(.day, from: date)
                
                // 1. هل هذا اليوم هو اليوم الذي ضغط عليه المستخدم؟
                let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                
                // 2. حالة التسجيل لهذا اليوم (من ViewModel)
                let logType = viewModel.selectedDateStatus(for: date) // تم تصحيح logType = viewModel.selectedDateStatus
                Button {
                    viewModel.selectedDate = date
                } label: {
                    VStack(spacing: 8) {
                        Text(dayNames[index]).font(.caption).foregroundColor(.gray)
                        Text("\(dayComponent)").font(.body)
                        // لون النص: أسود إذا كان محدد، أبيض في جميع الحالات الأخرى
                            .foregroundColor(isSelected ? .black : .white)
                            .frame(width: 35, height: 35)
                            .background(Circle().fill(
                                isColorForDay(isSelected: isSelected, logType: logType)
                            ))
                    }
                }
            }
        }
    }
    
    
    private func isColorForDay(isSelected: Bool, logType: LogType) -> Color {
        let learnedColor = Color.brown
        let freezedColor = Color.teal
        
        if isSelected {
            return primaryColor
        }
        
        switch logType {
        case .learned: return learnedColor
        case .freezed: return freezedColor
        case .none: return unselectedDarkColor
        }
    }
    @ViewBuilder
    func LearningStatusCards() -> some View {
        Text("Learning \(viewModel.currentStatus.subject)")
            .font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
        
        HStack {
            StatusCard(iconName: "flame.fill",
                       title: "\(viewModel.currentStatus.daysLearned)",
                       subtitle: "Days Learned",
                       color: learnedColor,
                       iconColor: primaryColor)
            
            StatusCard(iconName: "cube.fill",
                       title: "\(viewModel.currentStatus.daysFreezed)",
                       subtitle: "Day Freezed",
                       color: freezedColor,
                       iconColor: lightBlueColor)
        }
    }
    
    @ViewBuilder
    func BigActionButtons() -> some View {
        let status = viewModel.selectedDateStatus(for: viewModel.selectedDate)
        let isCurrentDay = Calendar.current.isDateInToday(viewModel.selectedDate)
        
        VStack(spacing: 20) {
            
            Group {
                if status == .none {
                    Button(action: viewModel.logAsLearned) {
                        VStack { Text("Log as"); Text("Learned") }
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 274,
                                   height: 274)
                            .background(Circle()
                                .fill(primaryColor))
                            .opacity(viewModel.isLearnButtonEnabled ? 1.0 : 0.5)
                    }
                    .disabled(!viewModel.isLearnButtonEnabled)
                } else {
                    Circle()
                        .fill(status == .learned ? learnedColor : freezedColor)
                        .frame(width: 274, height: 274)
                        .overlay(
                            VStack {
                                Text(status == .learned ? "Learned" : "Day")
                                Text(status == .learned ? (isCurrentDay ? "Today" : "Logged") : "Freezed")
                            }
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }
            
            // 2. زر Freezed السفلي
            if status == .none {
                Button(action: viewModel.logAsFreezed) {
                    Text("Log as Freezed")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 274)
                        .background(freezedColor)
                        .clipShape(Capsule())
                }
                .disabled(!viewModel.isFreezeButtonEnabled)
            } else {
                Text("Log as Freezed")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.clear)
                    .padding()
                    .frame(width: 274)
                    .background(Color.clear)
            }
        }
        
        // 3. عداد التجميد
        Text("\(viewModel.currentStatus.freezesUsed) out of \(viewModel.currentStatus.duration.maxFreezes) Freezes used")
            .foregroundColor(.gray)
            .font(.caption)
            .padding(.top, 10)
    }
    
    // --- المكونات والـ Extensions المدمجة ---
    
    struct StatusCard: View {
        let iconName: String
        let title: String
        let subtitle: String
        let color: Color // لون خلفية البطاقة (البني الداكن أو الأزرق الداكن)
        let iconColor: Color // لون أيقونة الشعلة أو المكعب
        
        var body: some View {
            HStack(spacing: 15) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(iconColor)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .background(color)
            .cornerRadius(60)
        }
    }
    
    // 🚨 واجهة اكتمال الهدف 🚨
    struct GoalCompletedView: View {
        @ObservedObject var viewModel: MainPageViewModel
        @Binding var showingUpdateSettingsSheet: Bool
        var body: some View {
            VStack(spacing: 40) {
                VStack(spacing: 15) {
                    Image(systemName: "hands.and.sparkles.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    Text("Will done!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("Goal completed! start learning again or\nset new learning goal")
                        .multilineTextAlignment(.center).foregroundColor(.gray)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // زر "Set new learning goal"
                Button("Set new learning goal") {
                    viewModel.isGoalCompleted = false // إخفاء واجهة الإنجاز
                    showingUpdateSettingsSheet = true // فتح شاشة إدارة الهدف
                }
                .font(.headline).foregroundColor(.white)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(60)
                
                // زر "Set same learning goal and duration"
                Button("Set same learning goal and duration") {
                    viewModel.resetGoalSame() // إعادة التعيين بنفس الإعدادات
                }.font(.subheadline)
                    .foregroundColor(.orange)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 25)
        }
    }
}

extension DateFormatter {
    static let monthAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        return formatter
    }()
}
