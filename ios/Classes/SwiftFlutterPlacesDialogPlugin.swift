import Flutter
import UIKit
import GooglePlacePicker
import GoogleMaps

    
public class SwiftFlutterPlacesDialogPlugin: NSObject, FlutterPlugin {

var controller: FlutterViewController!
var flutterResult: FlutterResult?

init(cont: FlutterViewController) {
  controller = cont;
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_places_dialog", binaryMessenger: registrar.messenger())

    let app =  UIApplication.shared
    let controller : FlutterViewController = app.delegate!.window!!.rootViewController as! FlutterViewController;
    let instance = SwiftFlutterPlacesDialogPlugin.init(cont: controller)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   switch (call.method) {
    case "setApiKey":
      GMSPlacesClient.provideAPIKey(call.arguments as! String)
      GMSServices.provideAPIKey(call.arguments as! String)
      result(true)
    case "showPlacePicker":
      let config = GMSPlacePickerConfig(viewport: nil)
     let placePicker = GMSPlacePickerViewController(config: config)
     placePicker.delegate = self
     flutterResult = result

     // Display the place picker. This will call the delegate methods defined below when the user
     // has made a selection.
     controller!.present(placePicker, animated: true, completion: nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

extension SwiftFlutterPlacesDialogPlugin : GMSPlacePickerViewControllerDelegate {
  public func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
    // Create the next view controller we are going to display and present it.

    // Dismiss the place picker.
    viewController.dismiss(animated: true, completion: nil)

    // Send the result back.  Yay!
  }

  public func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
    // In your own app you should handle this better, but for the demo we are just going to log
    // a message.
    NSLog("An error occurred while picking a place: \(error)")
  }

  public func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
    NSLog("The place picker was canceled by the user")

    // Dismiss the place picker.
    viewController.dismiss(animated: true, completion: nil)
  }
}