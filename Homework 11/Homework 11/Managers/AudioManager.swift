//
//  AudioManager.swift
//  Homework 11
//
//  Created by Иван Селюк on 29.06.22.
//

import AVFoundation
import UIKit

enum SoundsChoice: String {
    case click, salute
}

enum FileFormat: String {
    case mp3
}

class AudioManager {
    
    static let shared = AudioManager()
    var playerAudio: AVPlayer?
    var backgroundViewLayer: AVPlayerLayer?
    
    func playSoundPlayer(with name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: FileFormat.mp3.rawValue) else { return }
        let playerItam = AVPlayerItem(url: url)
        playerAudio = AVPlayer(playerItem: playerItam)
        playerAudio?.play()
    }
    
    func clearSoundPlayer() {
        playerAudio?.pause()
        playerAudio = nil
    }
}

