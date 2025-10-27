//
//  LearningApp.swift
//  Learning
//
//  Created by lamess on 27/04/1447 AH.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            GoalManagementView(
                            initialSubject: "Swift",
                            initialDuration: .week
                        )
        }
    }
}
