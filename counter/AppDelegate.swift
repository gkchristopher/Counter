import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customizeUI()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }

    func customizeUI() {
        UINavigationBar.appearance().barTintColor = Theme.Colors.navBar.color
        UINavigationBar.appearance().tintColor = Theme.Colors.navTint.color
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: Theme.Fonts.title.font,
            NSAttributedStringKey.foregroundColor: Theme.Colors.titleTint.color
        ]
    }
}

