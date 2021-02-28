import UIKit
import Flutter
import GoogleMaps
import UserNotifications
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

override init() {
    super.init()
    FirebaseApp.configure()
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GMSServices.provideAPIKey("AIzaSyADQl79AootGyhKCW8MQ8xxz561gPFu0rA")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // This method will be called when app received push notifications in foreground
      func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
      {
          completionHandler([.alert, .badge, .sound])
      }
}
