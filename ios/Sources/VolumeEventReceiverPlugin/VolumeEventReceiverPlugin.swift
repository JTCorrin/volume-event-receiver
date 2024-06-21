import Foundation
import Capacitor
import AVFoundation
import MediaPlayer

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(VolumeEventReceiverPlugin)
public class VolumeEventReceiverPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "VolumeEventReceiverPlugin"
    public let jsName = "VolumeEventReceiver"

    private var volumeView: MPVolumeView?
    private var audioSession: AVAudioSession?

    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "startListening", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopListening", returnType: CAPPluginReturnPromise),
    ]

    @objc func startListening(_ call: CAPPluginCall) {
        setupVolumeListener()
        call.resolve([
            "status": "started"
        ])
    }


    @objc func stopListening(_ call: CAPPluginCall) {
        removeVolumeListener()
        call.resolve([
            "status": "stopped"
        ])
    }

    private func setupVolumeListener() {
        // Set up audio session
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playback, mode: .default, options: [])
            try audioSession?.setActive(true)
        } catch {
            print("Failed to set up audio session")
        }
        
        // Set up MPVolumeView
        volumeView = MPVolumeView(frame: .zero)
        if let volumeView = volumeView {
            volumeView.isHidden = true
            self.bridge?.viewController?.view.addSubview(volumeView)
        }
        
        // Listen for volume changes
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)), name: .AVSystemController_SystemVolumeDidChangeNotification, object: nil)
        
        // Enable receiving remote control events
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func removeVolumeListener() {
        if let volumeView = volumeView {
            volumeView.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self, name: .AVSystemController_SystemVolumeDidChangeNotification, object: nil)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }


    @objc private func volumeChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let reason = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String,
           reason == "ExplicitVolumeChange" {
            notifyListeners("volumeButtonEvent", data: [
                "event": "volumeChanged"
            ])
        }
    }

    // Rest of api
}
