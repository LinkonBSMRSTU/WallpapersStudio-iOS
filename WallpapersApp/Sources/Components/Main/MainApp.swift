import SwiftUI
import ComposableArchitecture

@main
struct MainApp: App {
  let store = Store<MainState, MainAction>(
    initialState: MainState(),
    reducer: mainReducer,
    environment: ()
  )

  var body: some Scene {
    WindowGroup {
      if NSClassFromString("XCTestCase") == nil {
        EditorView(store: store.scope(
          state: \.editor,
          action: MainAction.editor
        ))
      }
    }
  }
}
