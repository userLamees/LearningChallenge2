//
//  GoalCompletedView.swift
//  Learning
//
//  Created by lamess on 03/05/1447 AH.
//
// GoalCompletedView.swift
import SwiftUI
import Foundation

// 🚨 يحتاج إلى binding لكي يفتح شاشة إدارة الهدف 🚨
struct GoalCompletedView: View {
    @ObservedObject var viewModel: MainPageViewModel
    @Binding var showingGoalManagerSheet: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            
            VStack(spacing: 15) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Will done!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Goal completed! start learning again or\nset new learning goal")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .padding(.top, 100)
            
            Spacer()
            
            // 2. زر "Set new learning goal"
            Button("Set new learning goal") {
                viewModel.isGoalCompleted = false // إخفاء واجهة الإنجاز
                showingGoalManagerSheet = true // 🚨 فتح شاشة إدارة الهدف (الخيار A) 🚨
            }
            .font(.headline).padding(.vertical, 15).frame(maxWidth: .infinity)
            .background(Color.orange).cornerRadius(60)
            
            // 3. زر "Set same learning goal and duration"
            Button("Set same learning goal and duration") {
                viewModel.resetGoalSame() // إعادة التعيين بنفس الإعدادات
            }
            .font(.subheadline).foregroundColor(.gray).padding(.bottom, 20)
        }
        .padding(.horizontal, 25)
    }
}

// ⚠️ الإضافة المطلوبة لربط الإشعارات (لزر "Set new goal") ⚠️
extension Notification.Name {
    static let openGoalManager = Notification.Name("openGoalManagerNotification")
}
