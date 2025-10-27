//
//  MonthYearPickerView.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

// MonthYearPickerView.swift
import SwiftUI


struct MonthYearPickerView: View {
    
    // 🔑 Binding لتحديث التاريخ المختار في الـ ViewModel الرئيسي 🔑
    @Binding var selectedDate: Date
    
    // لغرض إغلاق الشاشة المنبثقة
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView { // نستخدم NavigationView لتوفير شريط علوي
            VStack {
                
                DatePicker("اختر الشهر والسنة", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
            .navigationTitle("October 2025") // يمكن تحديث هذا الديناميكياً
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { // زر إغلاق (Done Button)
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.5)]) // تحديد ارتفاع النافذة المنبثقة
        .presentationBackground(Color.black)
    }
}
