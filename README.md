# WormholeKit

WormholeKit is a tiny SwiftUI library that lets you send a state change from anywhere in your app to a distant view or scene, without threading a `Binding` through every layer in between.

Think of it as a wormhole: you drop a value in at one point, and it comes out at another point that is bound to the same identifier.

## Motivation

In SwiftUI, sharing a piece of state between two places usually means lifting the state up and passing a `Binding` down through every view in the path.
This gets painful when the source and the destination are far apart, or when they live in completely separate branches of the view hierarchy such as two different `Scene`s.

WormholeKit connects a sender and a receiver by a shared `id` string, so the value travels directly from one to the other regardless of where they are.

## Features

- Send a value to any receiver identified by a `String`, from anywhere in the view hierarchy.
- Receive the value through a `@WormholeState` property wrapper that works like `@State`.
- Works across separate `Scene`s, which is handy for driving alerts, sheets, or windows.
- No shared singleton store to set up. Just match the `id`.

## Requirements

- iOS 18.0+ / macOS 15.0+
- Swift 6.2+

## Installation

Add WormholeKit to your project with Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/Kyome22/WormholeKit.git", from: "1.0.0")
]
```

Then add `"WormholeKit"` to your target's dependencies.

## Usage

Declare the receiving state with `@WormholeState`, giving it an `id`.
It behaves just like `@State`, so you can read its value and pass its projected `Binding` around as usual.

```swift
import SwiftUI
import WormholeKit

@main
struct ExampleApp: App {
    @WormholeState(id: "sample-alert") var showingAlert = false

    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        AlertScene(Text("Sample Alert"), isPresented: $showingAlert, actions: {})
    }
}
```

From anywhere else, grab the `sendIntoWormhole` action out of the environment and send a value to the same `id`.

```swift
import SwiftUI
import WormholeKit

struct ContentView: View {
    @Environment(\.sendIntoWormhole) var sendIntoWormhole

    var body: some View {
        Button("Open Alert") {
            sendIntoWormhole(id: "sample-alert", value: true)
        }
    }
}
```

Tapping the button flips `showingAlert` to `true` in the `App` scene, even though the button lives in a different scene, and the alert appears.

The value type just needs to be `Sendable` and `Hashable`, so you can send booleans, strings, enums, or your own value types.

## How it works

Under the hood, `sendIntoWormhole` posts a notification through `NotificationCenter` carrying the `id` and the value.
Each `@WormholeState` listens for that notification, matches on its own `id`, and updates its stored value when the identifiers match.
The listening is done through a buffered async sequence so that values sent in quick succession are not lost.

## License

WormholeKit is available under the MIT License. See the [LICENSE](LICENSE) file for details.
