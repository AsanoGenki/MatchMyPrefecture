//
//  BGMPlayerManager.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import AVFoundation
import SwiftUI

// 一部ChatGPTを使用して作成  プロンプト: アプリ起動時にBGMを流して、設定画面からそのBGMをオンオフできるアプリをSwiftUIで作成
// BGM処理
final class BGMPlayerManager: ObservableObject {
    static let shared = BGMPlayerManager()
    private var audioPlayer: AVAudioPlayer?
    private let errorManager = ErrorManager.shared
    // BGMのオンオフをAppStorageに保存
    @AppStorage("BGM") var isPlayingBGM: Bool = true
    private init() {
        configureAudioPlayer()
    }
    private func configureAudioPlayer() {
        if let bgmData = NSDataAsset(name: "BGM_Sweet_Peach")?.data {
            do {
                audioPlayer = try AVAudioPlayer(data: bgmData)
                audioPlayer?.volume = 0.07
                audioPlayer?.numberOfLoops = -1 // 無限ループ
                if isPlayingBGM {
                    audioPlayer?.play()
                }
            } catch {
                errorManager.readErrorMessage(
                    message: "BGMの読み込みに失敗しました。",
                    detail: "BGMを再生したい場合、再起動をしてください。"
                )
            }
        } else {
            errorManager.readErrorMessage(
                message: "BGMの読み込みに失敗しました。",
                detail: "BGMを再生したい場合、再起動をしてください。"
            )
        }
    }
    // BGM再生
    func playBGM() {
        audioPlayer?.stop()
        audioPlayer?.volume = 0.07
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    }
    // BGM停止
    func stopBGM() {
        audioPlayer?.stop()
    }
}
