/*
 WormholeStateStore.swift
 WormholeKit

 Created by Takuto Nakamura on 2026/07/05.
 
 */

import SwiftUI
import Observation

@MainActor @Observable
final class WormholeStateStore<D> where D : Sendable, D : Hashable {
    var id: String
    var value: D

    @ObservationIgnored private var task: Task<Void, Never>?

    init(id: String, value: D) {
        self.id = id
        self.value = value
        task = Task { [weak self] in
            let publisher = NotificationCenter.default.publisher(for: .didSentIntoWormhole)
            for await notification in publisher.bufferedValues() {
                guard let userInfo = notification.userInfo,
                      let id = userInfo["id"] as? String,
                      let value = userInfo["value"] as? D,
                      id == self?.id else {
                    continue
                }
                self?.value = value
            }
        }
    }

    deinit {
        task?.cancel()
        task = nil
    }
}
