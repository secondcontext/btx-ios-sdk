import BTXClientKit
import Foundation

enum AnonymousCommunityDemoConfigurationState {
    case ready(BTXConfiguration)
    case missing([String])
}

enum AnonymousCommunityDemoConfiguration {
    static func load(
        bundle: Bundle = .main,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) -> AnonymousCommunityDemoConfigurationState {
        let publishableClientKeyKey = "BTX_COMMUNITY_DEMO_PUBLISHABLE_CLIENT_KEY"

        func value(for key: String) -> String? {
            environment[key]?.demoValue
                ?? (bundle.object(forInfoDictionaryKey: key) as? String)?.demoValue
        }

        let publishableClientKey = value(for: publishableClientKeyKey)
        let missing = publishableClientKey == nil || publishableClientKey?.isPlaceholderDemoValue == true
            ? [publishableClientKeyKey]
            : []

        guard missing.isEmpty,
              let publishableClientKey
        else {
            return .missing(missing)
        }

        // Replace the placeholder in AnonymousCommunityDemo.local.xcconfig
        // with the publishable client key created for your iOS app. That key
        // is the only connection setting the SDK needs.
        return .ready(BTXConfiguration(
            publishableClientKey: publishableClientKey,
            // Enable only Community. Because .logs is omitted, the app does
            // not opt in to BTX host-app telemetry.
            features: [.community],
            communityOptions: BTXCommunityOptions(
                title: "Community",
                welcomeTitle: "Help shape Anonymy",
                welcomeMessage: "Share ideas, support what matters, and connect with the Anonymy team.",
                teamDisplayName: "Anonymy team",
                theme: BTXTheme(
                    primaryCTAColor: BTXColor(red: 0.42, green: 0.35, blue: 0.96)
                )
            )
        ))
    }
}

private extension String {
    var demoValue: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var isPlaceholderDemoValue: Bool {
        let normalized = lowercased()
        return normalized.contains("your_")
            || normalized.contains("replace_me")
            || normalized == "00000000-0000-0000-0000-000000000000"
    }
}
