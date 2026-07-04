/*
 WormholeStateStore.swift
 WormholeKit

 Created by Takuto Nakamura on 2026/07/05.

 */

import Foundation
import Observation

@MainActor @Observable
final class WormholeStateStore<D> where D : Sendable, D : Hashable {
    var id: String
    var value: D

    @ObservationIgnored nonisolated(unsafe) private var observer: (any NSObjectProtocol)?

    init(id: String, value: D) {
        self.id = id
        self.value = value
        observer = NotificationCenter.default.addObserver(
            forName: .didSentIntoWormhole,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let id = userInfo["id"] as? String,
                  let value = userInfo["value"] as? D else {
                return
            }
            MainActor.assumeIsolated {
                guard let self, id == self.id else {
                    return
                }
                self.value = value
            }
        }
    }

    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
