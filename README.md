# BTX iOS SDK

`BTXClientKit` is the BTX iOS SDK for customer-app telemetry and customer messaging. The host-facing API is the singleton `BTX` facade:

```swift
import BTXClientKit

BTX.configure(...)
BTX.identify(...)
BTX.log(...)
BTX.messenger.present()
```

The package targets iOS 17 or newer. The public package is distributed as a Swift Package Manager wrapper around a versioned `BTXClientKit` XCFramework.

## Add The Package

1. In Xcode, go to `File` then `Add Package Dependencies...`.
2. Enter `https://github.com/secondcontext/btx-ios-sdk.git`.
3. Select `BTXClientKit` and attach the library product to your app target.

## Configure

Configure once at app startup and identify whenever the signed-in customer changes. The same customer identifier is used for logs and messenger threads.

```swift
import BTXClientKit

@MainActor
func configureBTX(for user: User) {
    BTX.configure(
        BTXConfiguration(
            publishableClientKey: "cfk_...",
            appContext: BTXAppContext(
                appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                buildNumber: Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            ),
            features: [.logs, .messenger],
            messengerOptions: BTXMessengerOptions(
                feedback: BTXFeedbackOptions(
                    onShake: .enabled(includeScreenCapture: true),
                    onScreenshot: .enabled
                )
            )
        )
    )

    BTX.identify(
        BTXCustomer(
            externalID: user.id,
            name: user.name,
            email: user.email
        )
    )
}
```

Use a stable customer ID from your app. Do not use a random install ID for signed-in users.

Automatic feedback triggers are off by default. Enable `feedback.onShake` when
you want a device shake to open the compact feedback composer, and choose
whether that trigger should capture the active app window. Enable
`feedback.onScreenshot` when the SDK should notice a user screenshot and show
the dismissible “Send feedback about this screen?” prompt after the app is
active and no messenger surface is open. Accepting the prompt opens the same
compact composer with the captured app window as a removable local draft.

Customers can type or attach negotiated photo and video media from the system
Photo picker, preview and remove attachments before sending, and submit
attachment-only feedback. Captured and selected media stays local and uploads
only after Send; dismissing the prompt or composer discards it. Capture failure
never opens an empty screenshot prompt, while shake and manual capture failures
still fall back to the normal composer. Submitting creates a normal
customer-message thread in the background without opening the full messenger
sheet.

Host apps can expose that same compact composer from an explicit feedback
button, even when shake detection is disabled:

```swift
BTX.messenger.presentFeedbackReport(includeScreenshot: true)
```

`includeScreenshot` controls only that presentation. The capture is a removable
local draft and uploads only if the customer sends the report.

## Log Telemetry

`BTX.log(...)` accepts immediately and sends later. It returns `.enqueued` from the static facade, not a network-delivery result. The SDK buffers logs until identity and runtime transport are ready.

```swift
BTX.log(
    "checkout_started",
    properties: [
        "cartId": cart.id,
        "itemIds": cart.items.map(\.id),
        "totals": [
            "subtotal": cart.subtotal,
            "currency": cart.currency
        ]
    ]
)
```

Properties can be strings, ints, doubles, bools, `nil`, arrays, dictionaries keyed by `String`, or explicit `BTXJSONValue` values.

## Feature Flags

Feature flags load automatically after the SDK has a customer identity. Reads are synchronous and use the supplied fallback until the first evaluation is available or when a key is unknown.

```swift
let isEnabled = BTX.featureFlags.isEnabled(
    "settings.messenger-entry.enabled",
    fallback: false
)
```

Subscribe when host UI must update after an evaluation or identity change:

```swift
let featureFlagsCancellable = BTX.featureFlags.onChange { state in
    isMessengerEntryEnabled = state.isEnabled(
        "settings.messenger-entry.enabled",
        fallback: false
    )
}
```

`BTX.featureFlags.refresh()` explicitly refreshes the current identity's evaluation. Feature flags return to the unloaded state whenever the SDK configuration or customer identity changes.

## Present Messenger

```swift
BTX.messenger.present()
```

For a contextual entry point:

```swift
BTX.messenger.present(
    route: .compose(
        launchContext: BTXLaunchContext(
            entryPoint: "order_detail",
            sourceType: "order",
            sourceID: order.id,
            threadTitle: "Order Support",
            threadIntro: .card(
                title: "Order \(order.number)",
                subtitle: order.status
            ),
            threadAttributes: [
                "order": [
                    "id": .string(order.id),
                    "status": .string(order.status)
                ]
            ]
        )
    )
)
```

## Messenger Media Attachments

The messenger composer keeps attachment controls disabled until the SDK finishes negotiating attachment capabilities with the BTX messenger session. After negotiation, the composer only enables the image and video flows the backend allows for that customer session. Image flows remain available through paste, the native photo picker, and an inline recent-photo row when supported. Video attachments are selected through the native photo picker, validated locally against the negotiated video MIME allowlist, and sent as BTX-managed uploads. Add `NSPhotoLibraryUsageDescription` to the host app's `Info.plist` if you want the SDK to show recent photos directly above the composer. When recent photos are unavailable, such as missing permission copy, denied access, restricted access, or not-yet-granted access, the media button opens the native photo picker directly instead of showing an empty recent-photo row.

## Push Notifications

Push is optional. Messenger threads and foreground live updates work without APNs.

If the host app receives APNs tokens, forward them to the messenger facade:

```swift
func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
    Task { @MainActor in
        BTX.messenger.setDeviceToken(deviceToken)
    }
}
```

If the host app handles remote notifications manually, give BTX first chance for BTX messenger payloads:

```swift
if BTX.isMessengerNotification(userInfo) {
    Task { @MainActor in
        _ = BTX.messenger.handleRemoteNotification(userInfo)
    }
    completionHandler(.noData)
    return
}
```

By default the SDK requests notification authorization the first time messenger is presented. Hosts that own the permission prompt can disable this:

```swift
BTXConfiguration(
    publishableClientKey: "cfk_...",
    messengerOptions: BTXMessengerOptions(
        push: BTXPushConfiguration(
            automaticallyRequestsAuthorization: false
        )
    )
)
```

## Minimal Integration Diffs

### Log Only

```diff
+ import BTXClientKit

  func applicationDidFinishLaunching() {
+     BTX.configure(
+         BTXConfiguration(
+             publishableClientKey: "cfk_...",
+             features: [.logs]
+         )
+     )
  }

  func didSignIn(user: User) {
+     BTX.identify(
+         BTXCustomer(
+             externalID: user.id,
+             name: user.name,
+             email: user.email
+         )
+     )
  }

  func trackCheckoutStarted(cart: Cart) {
+     BTX.log(
+         "checkout_started",
+         properties: [
+             "cartId": cart.id,
+             "itemIds": cart.items.map(\.id)
+         ]
+     )
  }
```

### Messenger Only

```diff
+ import BTXClientKit

  func applicationDidFinishLaunching() {
+     BTX.configure(
+         BTXConfiguration(
+             publishableClientKey: "cfk_...",
+             features: [.messenger],
+             messengerOptions: BTXMessengerOptions(
+                 title: "Support",
+                 teamDisplayName: "Support Team"
+             )
+         )
+     )
  }

  func didSignIn(user: User) {
+     BTX.identify(
+         BTXCustomer(
+             externalID: user.id,
+             name: user.name,
+             email: user.email
+         )
+     )
  }

  func openSupport() {
+     BTX.messenger.present()
  }
```

### Logs And Messenger

```diff
+ import BTXClientKit

  func applicationDidFinishLaunching() {
+     BTX.configure(
+         BTXConfiguration(
+             publishableClientKey: "cfk_...",
+             messengerOptions: BTXMessengerOptions(
+                 title: "Support",
+                 teamDisplayName: "Support Team"
+             )
+         )
+     )
  }

  func didSignIn(user: User) {
+     BTX.identify(BTXCustomer(externalID: user.id, name: user.name, email: user.email))
  }

  func trackCheckoutStarted(cart: Cart) {
+     BTX.log("checkout_started", properties: ["cartId": cart.id])
  }

  func openSupport() {
+     BTX.messenger.present()
  }
```

## Public Surface

- `BTX.configure(_:)`
- `BTX.identify(_:)`
- `BTX.log(_:)`
- `BTX.messenger`
- `BTX.featureFlags`
- `BTXFeatureFlagsState`
- `BTX.isMessengerNotification(_:)`
- `BTXConfiguration`
- `BTXCustomer`
- `BTXAppContext`
- `BTXMessengerOptions`
- `BTXFeedbackOptions`
- `BTXPushConfiguration`
- `BTXTheme`, `BTXColorScheme`, `BTXColor`, `BTXFont`, `BTXImageResource`,
  `BTXPrimaryCTAStyle`, `BTXForegroundNotificationGlassStyle`
  - `BTXTheme.backgroundColor` controls the messenger sheet background.
  - `BTXTheme.surfaceColor` controls themed cards and neutral surfaces.
  - `BTXTheme.historyRowBackgroundColor` and `historyRowStrokeColor` independently theme conversation-history rows.
  - `BTXTheme.emptyStateLogo` controls the messenger home logo.
  - `BTXTheme.emptyStateShowsAppName` hides the generated app-name label when the supplied logo is already a complete wordmark.
  - `BTXTheme.emptyStateLogoMaxWidth` and `emptyStateLogoMaxHeight` constrain that logo.
  - `BTXTheme.emptyStateLogoToCTASpacing` controls the gap between the home logo and primary action.
  - `BTXTheme.primaryCTAColor` controls primary action fill.
  - `BTXTheme.primaryCTATextColor` controls primary action text and icon color.
  - `BTXTheme.primaryCTAStyle` supports `.glass` and `.solid`.
  - `BTXTheme.colorScheme` supports `.system`, `.light`, and `.dark` for hosts
    whose fixed palette must not follow the device appearance.
  - Message bubble, composer, and foreground-notification colors can be themed for light host apps.
  - The composer input uses only its Liquid Glass surface; it never adds a static outline around the interactive glass shape.
  - Foreground notifications can use `.regular` or `.clear` Liquid Glass and a banner-specific logo.
- `BTXImageLoader`, `BTXImageLoadContext`
- `BTXLogInput`, `BTXLogLevel`, `BTXLogDisposition`, `BTXLogValueConvertible`, `BTXJSONValue`
- `BTXLaunchContext`, `BTXMessengerEntryPoint`, `BTXPresentationRoute`
- `BTXThreadIntro`, `BTXThreadIntroRow`, `BTXThreadAttributeValue`, `BTXThreadAttribute`
- `BTXConversationStarterSection`, `BTXConversationStarter`, `BTXConversationStarterProvider`

`BTXRuntime` and the old `BTXCustomerMessenger*` client/service/view/modifier paths are implementation details, not host APIs.
