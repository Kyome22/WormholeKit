/*
 Publisher+Extension.swift
 WormholeKit

 Created by Takuto Nakamura on 2026/07/05.
 
 */

import Combine

extension Publisher where Self.Failure == Never {
    func bufferedValues() -> AsyncPublisher<Publishers.Buffer<Self>> {
        self.buffer(size: 5, prefetch: .keepFull, whenFull: .dropOldest)
            .values
    }
}
