//
//  VolumeEventReceiver.swift
//  VolumeDemo
//
//  Created by Mac Mini DN on 06/06/24.
//

import AVFoundation
import MediaPlayer

protocol VolumeButtonListenerDelegate: AnyObject {
    func volumeChanged(_ volume: Float)
}

class VolumeEventReceiver: NSObject {
    static let shared = VolumeEventReceiver()
    weak var delegate: VolumeButtonListenerDelegate?
    private var audioSession = AVAudioSession.sharedInstance()
    var player: AVAudioPlayer?
    
    private override init() {
        super.init()
        //TODO: Uncomment below in future
        //setupAndPlaySilentAudio()
        
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
    // func setupAndPlaySilentAudio() {
    //     guard let url = Bundle.main.url(forResource: "silent_audio", withExtension: "mp3") else {
    //         print("Silent audio file not found")
    //         return
    //     }
        
    //     do {
    //         try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
    //         try AVAudioSession.sharedInstance().setActive(true)
    //         player = try AVAudioPlayer(contentsOf: url)
    //         player?.numberOfLoops = -1 // Loop indefinitely
    //         player?.play()
    //     } catch {
    //         print("Failed to play silent audio: \(error)")
    //     }
    // }
    // @objc func startListening(_ call: CAPPluginCall)
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
