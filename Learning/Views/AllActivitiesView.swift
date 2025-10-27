//
//  AllActivitiesView.swift
//  Learning
//
//  Created by lamess on 05/05/1447 AH.
//
import SwiftUI


struct AllActivitiesView: View {
    @ObservedObject var viewModel: MainPageViewModel
    @Environment(\.dismiss) var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    let learnedColor = Color.orange
    let freezedColor = Color.teal
    
    private func getCurrentMonthStart() -> Date? {
        let calendar = viewModel.calendar
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)
    }
    
    private func getMonthsToDisplay() -> [Date] {
        let calendar = viewModel.calendar
        
        let startComponents = DateComponents(year: 2025, month: 1, day: 1)
        guard let startMonth = calendar.date(from: startComponents) else { return [] }
        
        let componentsOfEnd = DateComponents(year: 2027, month: 1, day: 1)
        guard let nextYearStart = calendar.date(from: componentsOfEnd),
              let endMonth = calendar.date(byAdding: .month, value: -1, to: nextYearStart) else { return [] }

        var months: [Date] = []
        var currentMonth = startMonth
        
        // 3. التكرار من يناير 2025 وحتى ديسمبر 2026 (بالترتيب التصاعدي)
        while currentMonth <= endMonth {
            months.append(currentMonth)
            
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) else {
                break
            }
            currentMonth = nextMonth
        }
        
        return months  }

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // التكرار على كل شهر
                        ForEach(getMonthsToDisplay(), id: \.self) { month in
                            VStack(alignment: .leading, spacing: 15) {
                                
                                // 1. عنوان الشهر والسنة
                                Text(month, format: .dateTime.month(.wide).year())
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                // 2. عرض أسماء أيام الأسبوع
                                HStack {
                                    ForEach(daysOfWeek, id: \.self) { day in
                                        Text(day)
                                            .font(.caption)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(Color.gray)
                                    }
                                }
                                .padding(.horizontal)
                                
                                // 3. شبكة التقويم الشهرية
                                LazyVGrid(columns: columns, spacing: 10) {
                                    let datesInMonth = viewModel.getDates(for: month)
                                    
                                    // المنطق الحاسم: إضافة خلايا فارغة للمحاذاة
                                    if let firstDay = datesInMonth.first,
                                       let weekday = viewModel.calendar.dateComponents([.weekday], from: firstDay).weekday {
                                        
                                        ForEach(0..<(weekday - 1), id: \.self) { _ in
                                            Text("")
                                        }
                                    }
                                    
                                    // عرض دوائر الأيام
                                    ForEach(datesInMonth, id: \.self) { date in
                                        DayCircle(date: date,
                                                  viewModel: viewModel,
                                                  learnedColor: learnedColor,
                                                  freezedColor: freezedColor)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .id(month)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 50)
                } // نهاية ScrollView
                
                .onAppear {
                    if let currentMonth = getCurrentMonthStart() {
                        withAnimation {
                            proxy.scrollTo(currentMonth, anchor: .top)
                        }
                    }
                }
            } // نهاية ScrollViewReader
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("All activities", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss() // لغلق الشاشة
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}


struct DayCircle: View {
    let date: Date
    @ObservedObject var viewModel: MainPageViewModel
    let learnedColor: Color
    let freezedColor: Color

    var body: some View {
        let status = viewModel.selectedDateStatus(for: date)
        let day = viewModel.calendar.component(.day, from: date)
        
        Text("\(day)")
            .font(.subheadline.bold())
            .frame(width: 35, height: 35)
            // لون النص: أسود إذا كان ملوناً، رمادي إذا كان غير مسجل
            .foregroundColor(status != .none ? .white : Color.gray)
            .background(backgroundColor(for: status))
            .clipShape(Circle())
            // لا تظهر الأيام المستقبلية غير المسجلة بكامل الشدة (Opacity)
            .opacity(date <= viewModel.calendar.startOfDay(for: Date()) || status != .none ? 1.0 : 0.4)
    }
    
    func backgroundColor(for status: LogType) -> Color {
        switch status {
        case .learned:
            return learnedColor
        case .freezed:
            return freezedColor
        case .none:
            // خلفية شفافة للأيام غير المسجلة
            return Color.clear
        }
    }
}
