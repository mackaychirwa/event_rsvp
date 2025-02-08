import Flutter
import UIKit
// import flutter_local_notifications
import flutter_background_service_ios
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    //   GeneratedPluginRegistrant.register(with: registry)
    // }
     SwiftFlutterBackgroundServicePlugin.taskIdentifier = "my_foreground"
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
