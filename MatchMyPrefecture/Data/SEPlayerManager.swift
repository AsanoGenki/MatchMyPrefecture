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
    @Published var errorMessage = ""
    @Published var errorMessageDetail = ""
    @Published var isShowingSEError = false
    let errorManager = ErrorManager.shared
    private init() {
        do {
            if let clickNomalData = NSDataAsset(name: "SE_click_normal")?.data {
                clickNomalSound = try AVAudioPlayer(data: clickNomalData)
                clickNomalSound?.volume = 0.7
            } else {
                readErrorMessage()
            }
            if let clickSmallData = NSDataAsset(name: "SE_click_small")?.data {
                clickSmallSound = try AVAudioPlayer(data: clickSmallData)
                clickSmallSound?.volume = 0.7
            } else {
                readErrorMessage()
            }
        } catch {
            readErrorMessage()
        }
    }
    // エラー発生時の処理
    private func readErrorMessage() {
        errorManager.errorMessage = "効果音の読み込みに失敗しました。"
        errorManager.errorMessageDetail = "効果音を再生したい場合、再起動をしてください。"
        errorManager.isShowingError = true
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
