//
//  UpdateLearningGoalView.swift
//  Learning
//
//  Created by lamess on 05/05/1447 AH.
//
// View: UpdateLearningGoalView.swift

// UpdateGoalSettingsView.swift (شاشة إعدادات وتحديث الهدف)

import SwiftUI

// يجب أن يكون هذا الـ ViewModel موجودًا لديكِ بالفعل
// ويحتوي على منطق التحذير (Streak will start over)
// class UpdateLearningGoalViewModel: ObservableObject { ... }

struct UpdateGoalSettingsView: View {
    
    @Environment(\.dismiss) var dismiss // لغرض إغلاق النافذة المنبثقة
    
    var onGoalUpdate: (String, LearningDuration) -> Void
    
    @StateObject var viewModel: UpdateLearningGoalViewModel
    
    // التهيئة لاستقبال القيم الأولية وبناء الـ ViewModel
    init(initialSubject: String, initialDuration: LearningDuration, onGoalUpdate: @escaping (String, LearningDuration) -> Void) {
        self.onGoalUpdate = onGoalUpdate
        
        let initialGoal = LearningGoal(goalText: initialSubject, duration: initialDuration)
        _viewModel = StateObject(wrappedValue: UpdateLearningGoalViewModel(initialGoal: initialGoal))
    }
    
    var body: some View {
        NavigationView { // نستخدم NavigationView لجعل العنوان وأزرار التعديل واضحة
            VStack(spacing: 30) {
                
                // 1. حقل إدخال الهدف (I want to learn)
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn").foregroundColor(.gray)
                    TextField("Goal subject", text: $viewModel.currentGoalText)
                        .font(.title3).foregroundColor(.white)
                    Rectangle().frame(height: 1).foregroundColor(.white.opacity(0.1))
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn it in a").foregroundColor(.gray)
                    HStack {
                        // استخدام LearningDuration الذي قمتِ بتعريفه
                        ForEach(LearningDuration.allCases, id: \.self) { duration in
                            Button(duration.rawValue) {
                                viewModel.currentDuration = duration
                            }
                            .frame(minWidth: 80).padding(.vertical, 8)
                            .background(viewModel.currentDuration == duration ? Color.orange : Color.gray.opacity(0.2))
                            .foregroundColor(.white).cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 20)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Learning Goal")
            .navigationBarTitleDisplayMode(.inline)
            
            // أزرار شريط التنقل (الرجوع والتأكيد)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left").foregroundColor(.orange)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.attemptUpdate() }) { // استدعاء منطق التحذير أولاً
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(viewModel.hasChanges ? .orange : .gray)
                    }
                    .disabled(!viewModel.hasChanges) // تعطيل الزر إذا لم يكن هناك تغيير
                }
            }
        }
        .preferredColorScheme(.dark)
        
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Update Learning Goal"),
                message: Text("If you update now, your streak will start over."),
                primaryButton: .default(Text("Dismiss"), action: {
                    viewModel.showAlert = false // إغلاق التنبيه
                }),
                secondaryButton: .destructive(Text("Update"), action: {
                    // 1. تنفيذ منطق التحديث (مثل إعادة تعيين الـ streak)
                    viewModel.confirmUpdate()
                    
                    // 2. تمرير القيم الجديدة إلى الشاشة الرئيسية (MainPageView)
                    onGoalUpdate(viewModel.currentGoalText, viewModel.currentDuration)
                    
                    dismiss()
                })
            )
        }
    }
}
