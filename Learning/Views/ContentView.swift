//
//  ContentView.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

import SwiftUI
import Foundation // لإصلاح أخطاء التاريخ (اختياري، لكن آمن)

// 🌟 هذا الملف هو View (واجهة المستخدم) 🌟

struct ContentView: View {
    
    // 🌟 1. ربط الـ View بالـ ViewModel 🌟
    @StateObject private var viewModel = ContentViewModel()
    
    @FocusState private var foucsed: Bool
    
    // تعريف الألوان المستخدمة (تبقى في الـ View للتصميم)
    let primaryColor = Color("StreakColor")
    let unselectedDarkColor = Color(red: 0.1, green: 0.1, blue: 0.1)
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color("BackgoundColor").edgesIgnoringSafeArea(.all)
                    .preferredColorScheme(.dark)
                
                VStack(alignment: .center, spacing: 30) {
                    
                    // === A. منطقة الشعار ===
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                            .frame(width: 109, height: 109).shadow(color: Color.orange.opacity(0.7), radius: 15).glassEffect()
                            .opacity(0.6)
                        
                        Image(systemName: "flame.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 67, height: 43)
                            .foregroundColor(Color.orange)
                    }
                    .padding(.vertical, 40)
                    
                    // === B. النصوص وحقل الإدخال (محاذاة لليسار) ===
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Hello Learner")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("This app will help you learn everyday!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 25)
                            
                            Text("I want to learn").font(.system(size: 25))
                            
                            // 🌟 الربط بـ viewModel.subjectToLearn 🌟
                            TextField("Swift", text: $viewModel.subjectToLearn)
                                .foregroundColor(.white)
                                .onSubmit {
                                    viewModel.startLearning() // استدعاء دالة المنطق
                                }
                                .focused($foucsed)
                            
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
                    
                    // === C. أزرار المدة ===
                    HStack(spacing: 10) {
                        
                        ForEach(LearningDuration.allCases, id: \.self) { duration in
                            Button {
                                // 🌟 التفاعل يمر عبر ViewModel 🌟
                                viewModel.selectedDuration = duration
                            } label: {
                                Text(duration.rawValue)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 15)
                            }
                            .buttonStyle(.glass)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                // 🌟 عرض الحالة من ViewModel 🌟
                                    .fill(duration == viewModel.selectedDuration ? primaryColor : unselectedDarkColor)
                                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 3)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                        
                        Spacer()
                    }
                    
                    
                   
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: MainPageView()) {
                            Text("Start learning")
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .frame(width: 200)
                                .background(primaryColor)
                                .clipShape(RoundedRectangle(cornerRadius: 60))
                        }
                        .buttonStyle(.plain)    .padding(.top, 50)
                        
                        Spacer()
                    }
                    
                }
                .padding(.bottom, 100)
                .padding(.horizontal, 25)
            }
            .navigationBarHidden(true)
        }
    }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
