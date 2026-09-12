import BTXClientKit
import SwiftUI

@main
struct AnonymousCommunityDemoApp: App {
    private let configurationState: AnonymousCommunityDemoConfigurationState

    init() {
        let configurationState = AnonymousCommunityDemoConfiguration.load()
        self.configurationState = configurationState

        if case let .ready(configuration) = configurationState {
            // Configure BTX once when the host app starts. Community creates a
            // stable anonymous member automatically, so no identify call is
            // needed for this app.
            BTX.configure(configuration)
        }
    }

    var body: some Scene {
        WindowGroup {
            AnonymousCommunityDemoView(configurationState: configurationState)
        }
    }
}
