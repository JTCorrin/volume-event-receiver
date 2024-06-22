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
    private var volumeObservation: NSKeyValueObservation?

    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "startListening", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopListening", returnType: CAPPluginReturnPromise),
    ]

    @objc func startListening(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.setupVolumeListener()
            call.resolve([
                "status": "started"
            ])
        }
    }


    @objc func stopListening(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.removeVolumeListener()
            call.resolve([
                "status": "stopped"
            ])
        }
    }

    private func setupVolumeListener() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setActive(true)
            try audioSession?.setCategory(.playback, mode: .default, options: [])
        } catch {
            print("Failed to set up audio session \(error)")
        }

        // Set up MPVolumeView
        volumeView = MPVolumeView(frame: CGRect(x: -100, y: 0, width: 10, height: 10))
        if let volumeView = volumeView {
            volumeView.isHidden = true
            self.bridge?.viewController?.view.addSubview(volumeView)
        }

        // Listen for volume changes using KVO
        volumeObservation = audioSession?.observe(\.outputVolume, options: [.new]) { [weak self] (audioSession, change) in
            if let newVolume = change.newValue {
                self?.volumeChanged(newVolume: newVolume)
            }
        }
        // Enable receiving remote control events
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func removeVolumeListener() {
        if let volumeView = volumeView {
            volumeView.removeFromSuperview()
        }
        volumeObservation = nil
        UIApplication.shared.endReceivingRemoteControlEvents()
    }

    private func volumeChanged(newVolume: Float) {
        notifyListeners("volumeButtonEvent", data: [
            "event": "volumeChanged",
            "volume": newVolume
        ])
    }
}
