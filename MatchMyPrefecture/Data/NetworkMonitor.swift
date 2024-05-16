//
//  NetworkMonitor.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/14/24.
//

import Network
import SwiftUI

final class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "NetworkMonitor")
        self.isConnected = false
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        self.monitor.start(queue: self.queue)
    }
}
