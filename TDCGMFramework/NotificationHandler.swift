
import Foundation
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    @Published private(set) var notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
 
    func requestUserNotification(title: String = "",body:String = "") {
        //先申请权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
              success, error in
                  if !success {
                      print("notification authorization is not granted")
                  } else {
                     
                      let content = UNMutableNotificationContent()
                      content.title = title
                      content.body = body
                      content.sound = UNNotificationSound.default
                               
                      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                      let request = UNNotificationRequest(identifier: String(Date().timestamp), content: content, trigger: trigger)

                      UNUserNotificationCenter.current().add(request)
                  }
        }
    }
    
    // Display the notification even if the app is front-most.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                                    completionHandler([.banner, .badge, .sound])
    }

}
