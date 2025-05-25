//
//  NotificationService.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/23/25.
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private init(){}

    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else if let error = error {
                print("❌ Error requesting permission: \(error)")
            }
        }
    }

    func scheduleNotification(habit: Habit) {
        let content = UNMutableNotificationContent()
        content.title = habit.title ?? ""
        content.body = habit.category ?? ""
        content.sound = .default

        let calendar = Calendar.current
        let date = habit.remainderTime ?? Date()
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: habit.id?.uuidString ?? UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Notification scheduled for \(habit.title ?? "")")
            }
        }
    }
}
