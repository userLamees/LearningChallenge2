//
//  ContentView.swift
//  Learning
//
//  Created by lamess on 27/04/1447 AH.
//
import SwiftUI

// تعريف المدة الزمنية للتعلم
enum LearningDuration: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct ContentView: View {
    let primaryColor = Color("StreakColor")

    @State private var subjectToLearn = ""
    @FocusState private var foucsed: Bool
    
    // 1. متغير حالة لتخزين المدة المختارة
    @State private var selectedDuration: LearningDuration = .week
    
    // تعريف اللون البرتقالي الأساسي
    let primaryOrange = Color(red: 0.85, green: 0.35, blue: 0.1, opacity: 1)
    // لون داكن وواضح للأزرار غير المختارة
    let unselectedDarkColor = Color(red: 0.1, green: 0.1, blue: 0.1)
    
    var body: some View {
        
        // الخلفية الرئيسية السوداء وتأثير شريط الحالة
        ZStack {
            Color("BackgoundColor").edgesIgnoringSafeArea(.all)
                .preferredColorScheme(.dark)
            
            VStack(alignment: .center, spacing: 30) {
                
                // === A. منطقة الشعار (تبقى في المنتصف) ===
                ZStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 109, height: 109)
                        .opacity(0.3)
                    
                    Image("Fire")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 67, height: 43)
                        .foregroundColor(Color.orange)
                }
                
                // === B. النصوص وحقل الإدخال (محاذاة لليسار) ===
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hello Learner")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("This app will help you learn everyday!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 25)
                        
                        Text("I want to learn").font(.system(size: 25))
                        
                        TextField("Swift", text: $subjectToLearn)
                            .foregroundColor(.white) // النص المُدخل أبيض
                            .onSubmit {
                                print(subjectToLearn)
                            }
                            .focused($foucsed)
                        
                        // الخط السفلي (إضافة مستطيل كخط)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.bottom, 10)
                        
                        Text("I want to learn in a ")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                        
                    }.onAppear{foucsed = true}
                    
                    Spacer() // يدفع النصوص لليسار
                }
                
                // === C. أزرار المدة (Custom Background Buttons) ===
                HStack(spacing: 15) {
                    
                    ForEach(LearningDuration.allCases, id: \.self) { duration in
                        Button {
                            selectedDuration = duration
                        } label: {
                            Text(duration.rawValue)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                        }.buttonStyle(.glass)
                        
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(duration == selectedDuration ? Color.orange : unselectedDarkColor)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 3)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Spacer()    }
                
                Button("Start learning") {
                    print("Starting learning: \(subjectToLearn) over \(selectedDuration.rawValue)")
                }
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .frame(width: 200)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .padding(.top,190)
                
                Spacer()
            }
            .padding(.top, 50)
            .padding(.horizontal, 25) // المسافة الجانبية تبقى ضرورية
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
