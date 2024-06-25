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
    var listenerName = "volumeButtonEvent"
    var bringToForeground = true
    var isListening = false

    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "startListening", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopListening", returnType: CAPPluginReturnPromise),
    ]

    @objc func startListening(_ call: CAPPluginCall) {
        if isListening {
            call.reject("Already Listening")
            return
        }
        self.listenerName = call.getString("listenerName") ?? listenerName
        VolumeEventReceiver.shared.delegate = self
        VolumeEventReceiver.shared.startListening()
        isListening = true
        call.resolve(["status":"Plugin Listening"])
    }


    @objc func stopListening(_ call: CAPPluginCall) {
        VolumeEventReceiver.shared.delegate = nil
        VolumeEventReceiver.shared.stopListening()
        isListening = false
        call.resolve(["message":"Plugin Removed \(listenerName)"])
    }


    @objc func volumeChanged(_ volume: Float) {
        self.notifyListeners(listenerName, data: ["data":"Event Fire", "volume":volume])
    }
}
