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
    private var clickNomalSound: AVAudioPlayer?
    private var clickSmallSound: AVAudioPlayer?
    @AppStorage("soundEffect") var isPlayingSE = true
    private let errorManager = ErrorManager.shared
    private init() {
        do {
            if let clickNomalData = NSDataAsset(name: "SE_click_normal")?.data {
                clickNomalSound = try AVAudioPlayer(data: clickNomalData)
                clickNomalSound?.volume = 0.7
            } else {
                errorManager.readErrorMessage(
                    message: "効果音の読み込みに失敗しました。",
                    detail: "効果音を再生したい場合、再起動をしてください。"
                )
            }
            if let clickSmallData = NSDataAsset(name: "SE_click_small")?.data {
                clickSmallSound = try AVAudioPlayer(data: clickSmallData)
                clickSmallSound?.volume = 0.7
            } else {
                errorManager.readErrorMessage(
                    message: "効果音の読み込みに失敗しました。",
                    detail: "効果音を再生したい場合、再起動をしてください。"
                )
            }
        } catch {
            errorManager.readErrorMessage(
                message: "効果音の読み込みに失敗しました。",
                detail: "効果音を再生したい場合、再起動をしてください。"
            )
        }
    }
    func playClickNormal() {
        guard isPlayingSE else {
            return
        }
        clickNomalSound?.play()
    }
    func playClickSmall() {
        guard isPlayingSE else {
            return
        }
        clickSmallSound?.play()
    }
}
