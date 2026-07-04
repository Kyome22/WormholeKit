import SwiftUI

@MainActor @propertyWrapper
public struct WormholeState<D>: DynamicProperty, Sendable where D : Sendable, D : Hashable {
    @State var store: WormholeStateStore<D>

    public var wrappedValue: D {
        get { store.value }
        nonmutating set { store.value = newValue  }
    }

    public var projectedValue: Binding<D> {
        .init(get: { wrappedValue }, set: { wrappedValue = $0 })
    }

    public init(wrappedValue: D, id: String) {
        _store = .init(wrappedValue: .init(id: id, value: wrappedValue))
    }
}
