//
//  SEPlayerManager.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI
import AVFoundation

final class SEPlayerManager: ObservableObject {
    static let shared = SEPlayerManager()
    private let clickNomalSound = try!  AVAudioPlayer(data: NSDataAsset(name: "SE_click_normal")!.data)
    private let clickSmallSound = try! AVAudioPlayer(data: NSDataAsset(name: "SE_click_small")!.data)
    @AppStorage("soundEffect") var isPlayingSE = true
    func playClickNormal() {
        if isPlayingSE {
            clickNomalSound.volume = 0.7
            clickNomalSound.play()
        } else {
            return
        }
    }
    func playClickSmall() {
        if isPlayingSE {
            clickSmallSound.volume = 0.7
            clickSmallSound.play()
        } else {
            return
        }
    }
}
