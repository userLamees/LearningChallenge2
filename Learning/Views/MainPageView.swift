//
//  MainPageView.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//
// MainPageView.swift
import SwiftUI

struct MainPageView: View {
    
    // 1. ربط الـ View بالـ ViewModel
    // يتم تمرير الموضوع والمدة من الشاشة السابقة (ContentView)
    @StateObject var viewModel: MainPageViewModel
    @State private var showingDatePickerSheet = false // لفتح شاشة اختيار التاريخ
    
    // الألوان (يجب تعريفها في Assets أو بهذا الشكل)
    let primaryColor = Color.orange
    let unselectedDarkColor = Color(red: 0.1, green: 0.1, blue: 0.1)

    // لتهيئة الـ View للمعاينة (تستخدم بيانات وهمية)
    init() {
        _viewModel = StateObject(wrappedValue: MainPageViewModel(subject: "Swift", duration: .week))
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                // 1. شريط العنوان (Activity)
                ActivityHeaderView()
                
                // 2. شريط التنقل بالتقويم (الشهر والسهم)
                CalendarNavigationHeader()
                
                // 3. عرض أيام الأسبوع
                WeekView(viewModel: viewModel)
                
                // 4. عرض حالة التعلم
                LearningStatusCards()
                
                Spacer()
                
                // 5. الأزرار الرئيسية (Log as Learned/Freezed)
                BigActionButtons()
                
                // 6. عداد التجميد
                Text("\(viewModel.currentStatus.freezesUsed) out of \(viewModel.currentStatus.duration.maxFreezes) Freezes used")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.bottom, 10)

            }
            .foregroundColor(.white)
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.updateWeek(for: Date())
        }
        // إزالة شريط التنقل وزر الرجوع (كما طلبت)
        .toolbar(.hidden, for: .navigationBar)
        
        // عرض شاشة اختيار الشهر/السنة عند الضغط على العنوان
        .sheet(isPresented: $showingDatePickerSheet) {
            MonthYearPickerView(
                viewModel: viewModel,
                isPresented: $showingDatePickerSheet
            )
            .presentationDetents([.fraction(0.5)])
            .presentationBackground(.ultraThinMaterial)
        }
    }
    
    // --- مكونات جزئية (Extracted Views) ---
    
    @ViewBuilder
    func ActivityHeaderView() -> some View {
        HStack {
            Text("Activity")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { print("Calendar Tapped") }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(10)
                        .background(Circle().fill(unselectedDarkColor).shadow(radius: 5))
                }
                
                Button(action: { print("Profile Tapped") }) {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(10)
                        .background(Circle().fill(unselectedDarkColor).shadow(radius: 5))
                }
            }
        }
    }
    
    @ViewBuilder
    func CalendarNavigationHeader() -> some View {
        HStack {
            // زر فتح شاشة اختيار التاريخ
            Button(action: { showingDatePickerSheet = true }) {
                HStack {
                    Text("\(viewModel.selectedDate, formatter: DateFormatter.monthAndYear)")
                        .font(.headline)
                        .foregroundColor(.white)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // أسهم التنقل بين الأسابيع
            Button { viewModel.navigateWeek(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 10)
            
            Button { viewModel.navigateWeek(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
    
    @ViewBuilder
    func WeekView(viewModel: MainPageViewModel) -> some View {
        let dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        
        HStack {
            ForEach(0..<viewModel.currentWeek.count, id: \.self) { index in
                VStack(spacing: 8) {
                    Text(dayNames[index])
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    let date = viewModel.currentWeek[index]
                    let dayComponent = Calendar.current.component(.day, from: date)
                    let isToday = Calendar.current.isDateInToday(date) // للتلوين
                    
                    Text("\(dayComponent)")
                        .font(.body)
                        .foregroundColor(isToday ? .black : .white)
                        .frame(width: 35, height: 35)
                        .background(
                            Circle()
                                .fill(isToday ? primaryColor : unselectedDarkColor)
                        )
                }
            }
        }
    }
    
    @ViewBuilder
    func LearningStatusCards() -> some View {
        Text("Learning \(viewModel.currentStatus.subject)")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
        
        HStack {
            StatusCard(iconName: "flame.fill", title: "\(viewModel.currentStatus.daysLearned)", subtitle: "Days Learned", color: Color.orange)
            StatusCard(iconName: "cube.fill", title: "\(viewModel.currentStatus.daysFreezed)", subtitle: "Day Freezed", color: Color.blue)
        }
    }
    
    @ViewBuilder
    func BigActionButtons() -> some View {
        VStack(spacing: 15) {
            // زر Log as Learned
            Button(action: viewModel.logAsLearned) {
                VStack { Text("Log as"); Text("Learned") }
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity).frame(height: 200)
                .background(Circle().fill(primaryColor))
                .opacity(viewModel.isLearnButtonEnabled ? 1.0 : 0.5)
            }
            .disabled(!viewModel.isLearnButtonEnabled)
            
            // زر Log as Freezed
            Button(action: viewModel.logAsFreezed) {
                Text("Log as Freezed")
                    .font(.headline).fontWeight(.medium).foregroundColor(.white).padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.teal)
                    .clipShape(Capsule())
            }
            .disabled(!viewModel.isFreezeButtonEnabled)
        }
    }
}

// مُكوّن صغير لكرت الحالة
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
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading).frame(height: 100)
        .background(unselectedDarkColor).cornerRadius(15)
    }
}

// مُعدّل لتنسيق التاريخ
extension DateFormatter {
    static let monthAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}
