import Foundation
import Capacitor
import AVFoundation

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(VolumeEventReceiverPlugin)
public class VolumeEventReceiverPlugin: CAPPlugin, CAPBridgedPlugin, VolumeButtonListenerDelegate {
    public let identifier = "VolumeEventReceiverPlugin"
    public let jsName = "VolumeEventReceiver"
    var listenerName = ""

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
        VolumeEventReceiver.shared.delegate = self
        VolumeEventReceiver.shared.startListening()
        call.resolve(["status":"Plugin Listening"])
        timerAction()
    }

    @objc func timerAction(){
        print("Timer Action!")
        timerEx=timerEx+1
        self.notifyListeners(listenerName, data: ["data":"Timer Execution \(timerEx)"])
    }


    @objc func stopListening(_ call: CAPPluginCall) {
        VolumeEventReceiver.shared.delegate = nil
        VolumeEventReceiver.shared.stopListening()

        resetTimer?.invalidate()
        
        timerAction()
        call.resolve(["message":"Plugin Removed \(listenerName)"])
    }


    @objc func volumeChanged(_ volume: Float) {
        print("Volum Change Invoked \(volume)")
        self.notifyListeners(listenerName, data: ["data":"Event Fire", "volume":volume])
    }
}
