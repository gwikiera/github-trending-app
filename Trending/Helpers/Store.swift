import ComposableArchitecture

#if DEBUG
extension Store {
    static func preview(_ state: State) -> Self {
        return self.init(initialState: state, reducer: EmptyReducer())
    }
}
#endif
