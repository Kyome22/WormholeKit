import Foundation
import Testing
@testable import WormholeKit

@MainActor
@Suite
struct WormholeStateStoreTests {
    private let send = SendIntoWormholeAction()

    private func waitUntil(
        timeout: Duration = .milliseconds(500),
        _ condition: @MainActor () -> Bool
    ) async {
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: timeout)
        while clock.now < deadline {
            if condition() {
                return
            }
            try? await Task.sleep(for: .milliseconds(1))
        }
    }

    @Test
    func updatesValueWhenIDMatches() async {
        let store = WormholeStateStore(id: "match", value: false)

        send(id: "match", value: true)
        await waitUntil { store.value }

        #expect(store.value == true)
    }

    @Test
    func ignoresValueWhenIDDiffers() async {
        let store = WormholeStateStore(id: "receiver", value: false)

        send(id: "other", value: true)
        try? await Task.sleep(for: .milliseconds(100))

        #expect(store.value == false)
    }

    @Test
    func ignoresValueWhenTypeMismatches() async {
        let store = WormholeStateStore(id: "typed", value: false)

        let userInfo: [AnyHashable: Any] = [
            "id": "typed",
            "value": "not a Bool"
        ]
        NotificationCenter.default.post(
            name: .didSentIntoWormhole,
            object: nil,
            userInfo: userInfo
        )
        try? await Task.sleep(for: .milliseconds(100))

        #expect(store.value == false)
    }

    @Test
    func deliversLatestValueForRapidSends() async {
        let store = WormholeStateStore(id: "rapid", value: 0)

        for number in 1...5 {
            send(id: "rapid", value: number)
        }
        await waitUntil { store.value == 5 }

        #expect(store.value == 5)
    }
}
