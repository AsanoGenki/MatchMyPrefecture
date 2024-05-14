//
//  BGMPlayerManager.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import AVFoundation
import SwiftUI

//一部ChatGPTを使用して作成  プロンプト: アプリ起動時にBGMを流して、設定画面からそのBGMをオンオフできるアプリをSwiftUIで作成
//BGM処理
final class BGMPlayerManager: ObservableObject {
    static let shared = BGMPlayerManager()
    private var audioPlayer: AVAudioPlayer?
    //BGMのオンオフをAppStorageに保存
    @AppStorage("BGM") var isPlayingBGM: Bool = true 
    init() {
        configureAudioPlayer()
    }
    private func configureAudioPlayer() {
        if isPlayingBGM {
            audioPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "BGM_Sweet_Peach")!.data)
            audioPlayer?.volume = 0.07
            audioPlayer?.numberOfLoops = -1 // 無限ループ
            audioPlayer?.play()
        }
    }
    //BGM再生
    func playBGM() {
        audioPlayer?.stop()
        audioPlayer?.volume = 0.07
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    }
    //BGM停止
    func stopBGM() {
        audioPlayer?.stop()
    }
}

