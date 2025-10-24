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
    @State private var showingDatePickerSheet = false
    
    let primaryColor = Color.orange
    let unselectedDarkColor = Color(red: 0.1, green: 0.1, blue: 0.1)
    let learnedColor = Color.brown // لون حالة Learned
    let freezedColor = Color.teal // لون حالة Freezed

    // دالة init التي تستقبل subject و duration
    init(subject: String, duration: LearningDuration) {
        _viewModel = StateObject(wrappedValue: MainPageViewModel(subject: subject, duration: duration))
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                ActivityHeaderView()
                CalendarNavigationHeader()
                WeekView(viewModel: viewModel)
                LearningStatusCards()
                
                Spacer()
                
                BigActionButtons() // تم تعديله ليكون ديناميكياً
                
                // تم نقل عرض عدد مرات التجميد داخل BigActionButtons
            }
            .foregroundColor(.white)
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.updateWeek(for: Date())
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showingDatePickerSheet) {
            MonthYearPickerView(
                viewModel: viewModel,
                isPresented: $showingDatePickerSheet
            )
            Text("Month/Year Picker View")
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
                Button(action: { print("Calendar Tapped") }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.white).font(.title2).padding(10)
                        .background(Circle().fill(unselectedDarkColor).shadow(radius: 5))
                }
                Button(action: { print("Profile Tapped") }) {
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

    // 🚨 تعديل: WeekView أصبح قابلاً للنقر 🚨
    @ViewBuilder
    func WeekView(viewModel: MainPageViewModel) -> some View {
        let dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        
        HStack {
            ForEach(0..<viewModel.currentWeek.count, id: \.self) { index in
                let date = viewModel.currentWeek[index]
                let dayComponent = Calendar.current.component(.day, from: date)
                let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                let logType = viewModel.currentStatus.loggedStatus.first { Calendar.current.isDate($0.key, inSameDayAs: date) }?.value ?? .none
                
                Button {
                    // تعيين هذا اليوم كـ selectedDate
                    viewModel.selectedDate = date
                } label: {
                    VStack(spacing: 8) {
                        Text(dayNames[index]).font(.caption).foregroundColor(.gray)
                        Text("\(dayComponent)").font(.body)
                            .foregroundColor(isSelected ? .black : .white)
                            .frame(width: 35, height: 35)
                            .background(Circle().fill(
                                // تحديد لون الدائرة بناءً على الحالة (محدد > مسجل > افتراضي)
                                isSelected ? primaryColor : (logType == .learned ? learnedColor : (logType == .freezed ? freezedColor : unselectedDarkColor))
                            ))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func LearningStatusCards() -> some View {
        Text("Learning \(viewModel.currentStatus.subject)")
            .font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
        
        HStack {
            StatusCard(iconName: "flame.fill", title: "\(viewModel.currentStatus.daysLearned)", subtitle: "Days Learned", color: Color.orange)
            StatusCard(iconName: "cube.fill", title: "\(viewModel.currentStatus.daysFreezed)", subtitle: "Day Freezed", color: Color.blue)
        }
    }

    // 🚨 التعديل الرئيسي: الأزرار الديناميكية 🚨
    @ViewBuilder
    func BigActionButtons() -> some View {
        let status = viewModel.selectedDateStatus
        let isCurrentDay = Calendar.current.isDateInToday(viewModel.selectedDate)
        
        VStack(spacing: 15) {
            // 1. الدائرة الرئيسية
            Group {
                if status == .none {
                    // الحالة الافتراضية: Log as Learned (قابلة للنقر)
                    Button(action: viewModel.logAsLearned) {
                        VStack { Text("Log as"); Text("Learned") }
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 200)
                        .background(Circle().fill(primaryColor)).opacity(viewModel.isLearnButtonEnabled ? 1.0 : 0.5)
                    }
                    .disabled(!viewModel.isLearnButtonEnabled)
                    
                } else {
                    // حالة التسجيل: عرض الحالة المسجلة (غير قابلة للنقر)
                    Circle()
                        .fill(status == .learned ? learnedColor : freezedColor)
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Text(status == .learned ? "Learned" : "Day")
                                Text(status == .learned ? (isCurrentDay ? "Today" : "Logged") : "Freezed")
                            }
                            .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                        )
                }
            }
            
            // 2. زر Freezed السفلي (يظهر فقط إذا لم يتم تسجيل اليوم)
            if status == .none {
                Button(action: viewModel.logAsFreezed) {
                    Text("Log as Freezed").font(.headline).fontWeight(.medium).foregroundColor(.white).padding()
                        .frame(maxWidth: .infinity).background(freezedColor).clipShape(Capsule())
                }
                .disabled(!viewModel.isFreezeButtonEnabled)
            } else {
                // عرض زر Freezed فارغ للحفاظ على التنسيق
                Text("Log as Freezed")
                    .font(.headline).fontWeight(.medium).foregroundColor(.clear).padding()
                    .frame(maxWidth: .infinity).background(Color.clear)
            }
        }
        
        // 3. عداد التجميد
        Text("\(viewModel.currentStatus.freezesUsed) out of \(viewModel.currentStatus.duration.maxFreezes) Freezes used")
            .foregroundColor(.gray)
            .font(.caption)
            .padding(.top, 10)
    }

    // ... (مكونات StatusCard و DateFormatter Extensions)
    struct StatusCard: View {
        let iconName: String
        let title: String
        let subtitle: String
        let color: Color
        let unselectedDarkColor = Color(red: 0.1, green: 0.1, blue: 0.1)
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Image(systemName: iconName).foregroundColor(color)
                Text(title).font(.title).fontWeight(.bold).foregroundColor(.white)
                Text(subtitle).font(.subheadline).foregroundColor(.gray)
            }
            .padding().frame(maxWidth: .infinity, alignment: .leading).frame(height: 100)
            .background(unselectedDarkColor).cornerRadius(15)
        }
    }
    
   
}

let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        return formatter
    }()

extension DateFormatter {
    static let monthAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}
