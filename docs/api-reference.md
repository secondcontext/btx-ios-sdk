# API reference

For full method signatures and platform availability, see the
[iOS API reference](https://btx.so/docs/ios/reference) and
[macOS API reference](https://btx.so/docs/macos/reference).

## Configuration and identity

- `BTX.configure(_:)`, `BTX.identify(_:)`
- `BTXConfiguration`, `BTXCustomer`, `BTXAppContext`
- `BTXClientKitVersion`

Start with the [iOS quickstart](quickstart.md) or [macOS guide](macos.md).

## Customer Messenger and feedback

- `BTX.messenger`, `BTXMessengerOptions`, `BTXFeedbackOptions`
- `BTXLaunchContext`, `BTXMessengerEntryPoint`, `BTXPresentationRoute`
- `BTXConversationPurpose`
- `BTXThreadIntro`, `BTXThreadIntroRow`, `BTXThreadAttributeValue`, `BTXThreadAttribute`
- `BTXConversationStarterSection`, `BTXConversationStarter`, `BTXConversationStarterProvider`
- `BTX.isMessengerNotification(_:)`, `BTXPushConfiguration`
- `submitFeedback(...)` and the contextual `presentFeedbackReport(...)` accept
  an optional `traceID` in 3.8.0.

See [Customer Messenger](customer-messenger.md), [rage-shake feedback](feedback.md),
[advanced feedback](advanced-feedback.md), and [push notifications](push-notifications.md).

## Help Center

- `BTX.helpCenter`, `BTXHelpCenter`
- `BTXHelpCenterOptions`, `BTXHelpCenterSheetHeight`, `BTXHelpCenterView`

See [Help Center](help-center.md) for setup, contextual articles, and embedded views.

## Telemetry

- `BTX.log(_:)`
- `BTXLogInput`, `BTXLogLevel`, `BTXLogDisposition`, `BTXLogValueConvertible`, `BTXJSONValue`
- `BTXRuntimeContext`, `BTXHostAppRuntimeContext`, `BTXOperatingSystemRuntimeContext`
- `BTXHostDeviceRuntimeContext`, `BTXRuntimeEnvironmentContext`, `BTXSDKRuntimeContext`, `BTXRuntimeIdentifier`
- `BTXAppSnapshotReason`
- `BTX.deviceSnapshots`, `BTXDeviceSnapshotReporter`, `BTXDeviceSnapshot`
- `BTXDeviceIdentifier`, `BTXDeviceSnapshotReason`

See [telemetry](telemetry.md) and [hardware telemetry](device-telemetry.md).

## Feature flags

- `BTX.featureFlags`, `BTXFeatureFlagsState`

See [feature flags](feature-flags.md) for fallback values and observable updates.

## Theming

- `BTXTheme`, `BTXThemePreset`, `BTXThemePalette`, `BTXColorScheme`
- `BTXColor`, `BTXFont`, `BTXImageResource`
- `BTXPrimaryCTAStyle`, `BTXForegroundNotificationGlassStyle`
- `BTXImageLoader`, `BTXImageLoadContext`

See [theming](theming.md) for presets, brand colors, artwork, and surface options.

## Additional features

- `BTX.community`, `BTXCommunityOptions`
- `BTXCommunityIdea`, `BTXCommunityReply`
- `BTXCommunityPresentationResult`, `BTXCommunityPresentationFailure`
- `BTX.inAppCampaigns.setPresentationReady(_:)`, `BTXInAppCampaignOptions`

See [Community and Campaigns](additional-features.md).

[All guides](README.md)
