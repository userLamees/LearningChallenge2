//
//  UpdateLearningGoalViewModel.swift
//  Learning
//
//  Created by lamess on 05/05/1447 AH.
//
// ViewModel: UpdateLearningGoalViewModel.swift

import SwiftUI
internal import Combine

class UpdateLearningGoalViewModel: ObservableObject {
    
    // 1. المتغيرات القابلة للملاحظة (Observed Properties)
    @Published var currentGoalText: String // النص الحالي للهدف
    @Published var currentDuration: LearningDuration // المدة الزمنية الحالية
    @Published var showAlert: Bool = false // لعرض رسالة التأكيد عند التحديث
    
    // الهدف الأصلي الذي تم إدخاله في البداية
    private var originalGoal: LearningGoal
    
    // 2. التهيئة (Initialization)
    init(initialGoal: LearningGoal) {
        self.originalGoal = initialGoal
        self.currentGoalText = initialGoal.goalText
        self.currentDuration = initialGoal.duration
    }
    
    // 3. المنطق (Business Logic)
    
    // هل هناك أي تغييرات تستدعي التحديث؟
    var hasChanges: Bool {
        return currentGoalText != originalGoal.goalText || currentDuration != originalGoal.duration
    }
    
    // دالة لاستدعاء رسالة التنبيه قبل التحديث النهائي
    func attemptUpdate() {
        if hasChanges {
            showAlert = true
        } else {
            // يمكن إضافة منطق آخر هنا إذا لم يكن هناك تغيير
            print("No changes to update.")
        }
    }
    
    // دالة تنفيذ عملية التحديث الفعلية
    func confirmUpdate() {

        let newGoal = LearningGoal(goalText: currentGoalText, duration: currentDuration)
    print("Goal updated successfully! New streak must start.")
        showAlert = false // إغلاق التنبيه
        // يمكن إضافة منطق للانتقال إلى الشاشة الرئيسية هنا
    }
    
    // دالة التراجع عن التغييرات (إذا لزم الأمر)
    func dismissChanges() {
        // يمكنك هنا تعيين currentGoalText و currentDuration للقيم الأصلية
        currentGoalText = originalGoal.goalText
        currentDuration = originalGoal.duration
        showAlert = false
    }
}
