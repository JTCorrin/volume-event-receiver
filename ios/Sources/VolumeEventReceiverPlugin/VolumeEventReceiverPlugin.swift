import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(VolumeEventReceiverPlugin)
public class VolumeEventReceiverPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "VolumeEventReceiverPlugin"
    public let jsName = "VolumeEventReceiver"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "startListening", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopListening", returnType: CAPPluginReturnPromise),
    ]

    @objc func startListening(_ call: CAPPluginCall) {
        guard let listenerName = call.options["listenerName"] as? String else {
            call.reject("Must provide an listener name")
            return
        }

        self.listenerName = call.getString("listenerName") ?? listenerName

        VolumeButtonDetector.shared.delegate = self
        VolumeButtonDetector.shared.startListening()

        call.resolve(["message":"Plugin Activated! \(listenerName)"])
        
        timerAction()
    }

    @objc func timerAction(){
        print("Timer Action!")
        timerEx=timerEx+1
        self.notifyListeners(listenerName, data: ["data":"Timer Execution \(timerEx)"])
    }

    @objc func stopListening(_ call: CAPPluginCall) {
        
        VolumeButtonDetector.shared.delegate = nil
        VolumeButtonDetector.shared.stopListening()

        resetTimer?.invalidate()
        
        timerAction()
        call.resolve(["message":"Plugin Removed \(listenerName)"])
    }


    @objc func volumeChanged(_ volume: Float) {
        print("Volum Change Invoked \(volume)")
        self.notifyListeners(listenerName, data: ["data":"Event Fire", "volume":volume])
    }

    // Rest of api
}
