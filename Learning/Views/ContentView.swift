//
//  ContentView.swift
//  Learning
//
//  Created by lamess on 01/05/1447 AH.
//

import SwiftUI
import Foundation // مطلوب لـ ContentViewModel

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @FocusState private var focused: Bool
    
    let primaryColor = Color.orange // استخدمنا لون ثابت بدلاً من "StreakColor"
    let unselectedDarkColor = Color(red: 0.1, green: 0.1, blue: 0.1)
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                    .preferredColorScheme(.dark)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    // ... (الجزء A: الأيقونة)
                    ZStack {
                        Circle()
                            .fill(unselectedDarkColor)
                            .frame(width: 109, height: 109)
                            .shadow(color: Color.orange.opacity(0.7), radius: 15)
                            .opacity(0.6)
                        
                        Image(systemName: "flame.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 67, height: 43)
                            .foregroundColor(Color.orange)
                    }
                    .padding(.vertical, 40)
                    
                    // ... (الجزء B: النصوص وحقل الإدخال)
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Hello Learner").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                            
                            Text("This app will help you learn everyday!").font(.subheadline).foregroundColor(.gray).padding(.bottom, 25)
                            
                            Text("I want to learn").font(.system(size: 25)).foregroundColor(.white)
                            
                            TextField("Swift", text: $viewModel.subjectToLearn)
                                .foregroundColor(.white)
                                .onSubmit { viewModel.startLearning() }
                                .focused($focused)
                            
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.5)).padding(.bottom, 10)
                            
                            Text("I want to learn in a ").foregroundColor(.gray).font(.system(size: 25))
                            
                        }.onAppear{focused = true}
                        
                        Spacer()
                    }
                    
                    // ... (الجزء C: أزرار المدة)
                    HStack(spacing: 10) {
                        ForEach(LearningDuration.allCases, id: \.self) { duration in
                            Button {
                                viewModel.selectedDuration = duration
                            } label: {
                                Text(duration.rawValue)
                                    .font(.headline).fontWeight(.medium).foregroundColor(.white)
                                    .padding(.vertical, 6).padding(.horizontal, 15)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(duration == viewModel.selectedDuration ? primaryColor : unselectedDarkColor)
                                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 3)
                            ).buttonStyle(.glass)
                        }
                        Spacer()
                    }
                    
                    // ... (الجزء D: زر "Start Learning!")
                    HStack {
                        Spacer()
                        
                        // 🚨 الحل: تمرير البيانات مباشرة إلى init() الجديد لـ MainPageView 🚨
                        NavigationLink(destination:
                            MainPageView(
                                subject: viewModel.subjectToLearn,
                                duration: viewModel.selectedDuration
                            )
                        ) {
                            Text("Start Learning!")
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .frame(width: 180)
                                .background(Color.orange.opacity(0.7))
                                .clipShape(RoundedRectangle(cornerRadius: 60))
                        }.buttonStyle(.glass)
                        .padding(.top, 150)
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 100)
                .padding(.horizontal, 25)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
