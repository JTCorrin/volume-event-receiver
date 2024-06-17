import Foundation
import AVFoundation
import MediaPlayer

protocol VolumeButtonListenerDelegate: AnyObject {
    func volumeChanged(_ volume: Float)
}

@objc public class VolumeEventReceiver: NSObject {

    static let shared = VolumeButtonDetector()
    weak var delegate: VolumeButtonListenerDelegate?
    private var audioSession = AVAudioSession.sharedInstance()
    var player: AVAudioPlayer?

    private override init() {
        super.init()        
    }

    private func configureAudioSession() {
        do {
            try audioSession.setActive(true)
            try audioSession.setCategory(.playback, options: [])
            print("Audio Session Configured")
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }


    //@objc func startListening(_ call: CAPPluginCall)
    func startListening() {
        print("Start Audio Session Listen")
        configureAudioSession()
        observeVolumeChanges()
    }

    //@objc func stopListening(_ call: CAPPluginCall)
    func stopListening() {
        print("Stop Audio Session Listen")
        audioSession.removeObserver(self, forKeyPath: "outputVolume")
    }

    private func observeVolumeChanges() {
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: [.new, .old], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume", let volume = (change?[.newKey] as? NSNumber)?.floatValue {
            print("Volume changed to: \(volume)")
            self.delegate?.volumeChanged(volume)
        }
    }

    deinit {
        audioSession.removeObserver(self, forKeyPath: "outputVolume")
    }
}
