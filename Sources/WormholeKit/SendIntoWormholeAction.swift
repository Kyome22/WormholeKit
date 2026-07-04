/*
 SendIntoWormholeAction.swift
 WormholeKit

 Created by Takuto Nakamura on 2026/07/05.
 
 */

import SwiftUI

public struct SendIntoWormholeAction {
    public func callAsFunction<D>(id: String, value: D) where D : Sendable, D : Hashable {
        let userInfo: [AnyHashable: Any] = [
            "id": id,
            "value": value
        ]
        NotificationCenter.default.post(
            name: .didSentIntoWormhole,
            object: nil,
            userInfo: userInfo
        )
    }
}

extension EnvironmentValues {
    @Entry public var sendIntoWormhole = SendIntoWormholeAction()
}
