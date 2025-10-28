Project Purpose and Functionality
This application is a SwiftUI productivity tool designed to enforce consistent learning habits by establishing a reliable and strict progress Streak system. Its primary purpose is to help users commit to a learning goal and maintain their momentum over a defined period.

FEAT 1: Goal Management and Tracking
The app begins with Onboarding, where the user sets a subject ( "Swift") and defines the learning duration (Week, Month, Year). This initiates the tracking process. Users can modify this goal anytime via the pen Icon (Settings), though updating the goal will explicitly reset their current streak and progress metrics. The system then tracks accumulated Days Learned and Days Freezed against the duration target.

FEAT 2: Strict Sequential Logging
The core functionality enforces Sequential Logging. The large "Log as Learned" and "Log as Freezed" buttons are only enabled for the next available day in the sequence, regardless of whether that day is in the past, present, or future. This prevents users from skipping days or logging activities randomly. Tapping "Log as Learned" increases the streak count, while tapping "Log as Freezed" uses a Freeze token (limited use) to mark the day complete and preserve the streak without counting it as learned activity.

FEAT 3: Goal Completion and History
When the target duration is met ( 30 Days Learned), the app transitions to a Goal Completed screen. From there, the user can choose to reset and start a new learning streak with the same task or define a completely new subject. For historical review, tapping the Calendar Icon on the Activity Page navigates the user to the "All Activities" page. This page displays a comprehensive, historical calendar log of all months from 2025 onwards, showing Learned days (Orange/Brown) and Freezed days (Blue/Teal) for easy progress visualization.
