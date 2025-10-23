//
//  MonthYearPickerView.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

// MonthYearPickerView.swift
import SwiftUI

struct MonthYearPickerView: View {
    @ObservedObject var viewModel: MainPageViewModel
    @Binding var isPresented: Bool
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack(alignment: .leading) {
            // زر الإغلاق
            HStack {
                Spacer()
                Button("Done") {
                    isPresented = false
                    // تحديث الواجهة الرئيسية بعد اختيار تاريخ جديد
                    viewModel.updateWeek(for: viewModel.selectedDate)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)
            
            HStack(spacing: 30) {
                MonthPickerColumn(selectedDate: $viewModel.selectedDate)
                YearPickerColumn(selectedDate: $viewModel.selectedDate, currentYear: currentYear)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(15)
    }
}

// مكون فرعي لعمود الأشهر
struct MonthPickerColumn: View {
    @Binding var selectedDate: Date
    let months = Calendar.current.monthSymbols
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("October 2025 >").font(.caption).foregroundColor(.gray)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(months.indices, id: \.self) { index in
                            let monthIndex = index + 1
                            let isSelected = Calendar.current.component(.month, from: selectedDate) == monthIndex

                            Text(months[index])
                                .font(isSelected ? .title : .headline)
                                .fontWeight(isSelected ? .bold : .regular)
                                .foregroundColor(isSelected ? .white : .gray)
                                .id(monthIndex)
                                .onTapGesture {
                                    // تحديث الشهر في التاريخ المختار
                                    let newMonth = monthIndex
                                    var components = Calendar.current.dateComponents([.year, .day], from: selectedDate)
                                    components.month = newMonth
                                    if let newDate = Calendar.current.date(from: components) {
                                        selectedDate = newDate
                                    }
                                }
                        }
                    }
                    .padding(.vertical)
                }
                .frame(width: 150, height: 250)
                .onAppear {
                    let currentMonth = Calendar.current.component(.month, from: selectedDate)
                    proxy.scrollTo(currentMonth, anchor: .center)
                }
            }
        }
    }
}

// مكون فرعي لعمود السنوات
struct YearPickerColumn: View {
    @Binding var selectedDate: Date
    let currentYear: Int
    let yearsRange = 2018...2028 // نطاق مرئي للسنوات
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("2021").font(.caption).foregroundColor(.gray)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(yearsRange.map { $0 }, id: \.self) { year in
                            let isSelected = Calendar.current.component(.year, from: selectedDate) == year

                            Text("\(year)")
                                .font(isSelected ? .title : .headline)
                                .fontWeight(isSelected ? .bold : .regular)
                                .foregroundColor(isSelected ? .white : .gray)
                                .id(year)
                                .onTapGesture {
                                    // تحديث السنة في التاريخ المختار
                                    let newYear = year
                                    var components = Calendar.current.dateComponents([.month, .day], from: selectedDate)
                                    components.year = newYear
                                    if let newDate = Calendar.current.date(from: components) {
                                        selectedDate = newDate
                                    }
                                }
                        }
                    }
                    .padding(.vertical)
                }
                .frame(width: 100, height: 250)
                .onAppear {
                    let selectedYear = Calendar.current.component(.year, from: selectedDate)
                    proxy.scrollTo(selectedYear, anchor: .center)
                }
            }
        }
    }
}
