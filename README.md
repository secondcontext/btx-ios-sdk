# BTX iOS SDK

`BTXClientKit` is the BTX iOS SDK for customer-app telemetry, customer messaging,
and in-app community. The host-facing API is the singleton `BTX` facade:

```swift
import BTXClientKit

BTX.configure(...)
BTX.identify(...)
BTX.log(...)
BTX.messenger.present()
BTX.community.present()
```

The package targets iOS 17 or newer. The public package is distributed as a Swift Package Manager wrapper around a versioned `BTXClientKit` XCFramework.

## Add The Package

1. In Xcode, go to `File` then `Add Package Dependencies...`.
2. Enter `https://github.com/secondcontext/btx-ios-sdk.git`.
3. Select `BTXClientKit` and attach the library product to your app target.

## Configure

Configure once at app startup. Identify whenever the signed-in customer
changes so logs, Messenger, and Community use that customer. If no customer is
identified, Community automatically uses an anonymous member identity.

Telemetry is opt-in. The default feature set enables Messenger only; add
`.logs` when the host app intends to send runtime snapshots or custom logs.

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
            features: [.logs, .messenger, .community],
            messengerOptions: BTXMessengerOptions(
                feedback: BTXFeedbackOptions(
                    onShake: .enabled(includeScreenCapture: true),
                    onScreenshot: .enabled
                )
            ),
            communityOptions: BTXCommunityOptions(
                title: "Nirva Community",
                welcomeTitle: "Help shape Nirva",
                welcomeMessage: "Share ideas, support what matters, and hear directly from the Nirva team.",
                teamDisplayName: "Nirva team"
            )
        )
    )

    BTX.identify(
        BTXCustomer(
            externalID: user.id,
            name: user.name,
            email: user.email,
            phone: user.phoneE164
        )
    )
}
```

Use a stable customer ID from your app. Do not use a random install ID for
signed-in users. `phone` is optional; when supplied, normalize it to E.164.

When `.logs` is enabled, `BTXConfiguration` enriches `appContext` with a
privacy-safe runtime context at startup. It includes the host app name, bundle identifier,
version and build, iOS version, Apple device family and model identifier, CPU
architecture, and simulator state. It intentionally excludes the user-assigned
device name, serial number, `identifierForVendor`, advertising identifiers, and
other stable personal identifiers. When logs are enabled, the SDK also records
one canonical, cross-platform `app.snapshot` telemetry event after the runtime starts. Host apps
can use `BTXAppContext.current()` when they need the same standardized snapshot
directly. The runtime context always includes the BTX SDK name and exact version:
source checkouts report `development`, while published XCFramework builds report
their release tag through `BTXClientKitVersion.current`.

Automatic feedback triggers are off by default. Enable `feedback.onShake` when
you want a deliberate device shake to open a compact confirmation sheet with
one action for feedback or bugs and a shake toggle. Continuing opens the feedback
composer; the keyboard stays hidden until the customer selects the text field.
Choose whether that trigger captures the active app window before the prompt
appears. Enable
`feedback.onScreenshot` when the SDK should notice a user screenshot and show
the dismissible “Send feedback about this screen?” prompt after the app is
active and no messenger surface is open. Accepting the prompt opens the same
compact composer with the captured app window as a removable local draft.

Use `BTX.feedbackPreferences.isShakeEnabled` for the host Settings toggle. The
observable preference is shared with the shake prompt, defaults to `true`, and
persists on this installation across launches and sign-out. It does not override
the host's `onShake` opt-in or the SDK's identity requirements. Turning it off
stops motion updates; manual feedback and screenshot triggers remain available.

Physical devices use Core Motion user acceleration, excluding gravity. BTX
requires four alternating impulses above 2.2 g within 0.85 seconds, spanning at
least 0.3 seconds, with a 2-second cooldown. It ignores the first 1.5 seconds of
motion after activation and resets after sensor interruptions. Motion sampling
stops while inactive or SDK UI is open. These are BTX tuning values, not an iOS
standard; validate deliberate shaking, walking, opening the app and setting the
phone down on physical devices before release. Simulator's Device > Shake tests
the presentation flow and bypasses accelerometer classification.

Customers can type or attach negotiated photo and video media from the system
Photo picker, preview and remove attachments before sending, and submit
attachment-only feedback. Captured and selected media stays local and uploads
only after Send; dismissing the prompt or composer discards it. Capture failure
never opens an empty screenshot prompt, while shake and manual capture failures
still fall back to the normal composer. Submitting creates a normal
customer-message thread in the background without opening the full messenger
sheet. The SDK marks that thread with `BTXConversationPurpose.feedback`, so BTX
operator surfaces can distinguish it from a support request while keeping it
replyable.

Host apps can expose that same compact composer from an explicit feedback
button, even when shake detection is disabled:

```swift
BTX.messenger.presentFeedbackReport(includeScreenshot: true)
```

`includeScreenshot` controls only that presentation. The capture is a removable
local draft and uploads only if the customer sends the report.

For contextual feedback on a host-owned item, identify the event subject and
reuse a stable source identity in the launch context. Positive feedback can be
submitted without UI, while negative feedback can open the compact follow-up
composer:

```swift
let prompt = BTXFeedbackPrompt(
    subject: "Nirva Card",
    question: "What could be better?",
    choices: ["Incorrect", "Not relevant to me"]
)

await BTX.messenger.submitFeedback(
    rating: .positive,
    subject: "Nirva Card",
    launchContext: cardLaunchContext
)

BTX.messenger.presentFeedbackReport(
    rating: .negative,
    previousRating: .positive,
    prompt: prompt,
    launchContext: cardLaunchContext
)
```

Passing `previousRating` records a rating change in the same source-scoped
thread instead of presenting it as a new initial rating.

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

## Report Physical Devices

Hosts only map their hardware-specific state into `BTXDeviceSnapshot`. The SDK owns
coalescing, deduplication, lifecycle reasons, disconnect cancellation, and re-reporting
an active device after the identified customer or BTX project changes.

```swift
BTX.deviceSnapshots.refresh(
    connectionKey: peripheral.identifier.uuidString
) {
    BTXDeviceSnapshot(
        identifiers: [
            .vendorHardwareID(
                wearable.hardwareID,
                namespace: "example.hardware_uid"
            ),
            .serialNumber(
                wearable.serialNumber,
                namespace: "example.serial_number"
            ),
            .coreBluetoothPeripheralUUID(peripheral.identifier),
        ],
        manufacturer: "Example",
        category: "wearable",
        model: wearable.model,
        firmwareVersion: wearable.firmwareVersion,
        batteryPercent: wearable.batteryPercent
    )
}
```

The `connectionKey` stays local to the SDK and is never transmitted. Call
`BTX.deviceSnapshots.disconnect(connectionKey:)` when that hardware connection ends.
Never put pairing secrets, ownership tokens, or credentials in a device identifier.

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
            conversationPurpose: .support,
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

## Present Community

Enable `.community`, then connect the host app's Community entry point to:

```swift
BTX.configure(
    BTXConfiguration(
        publishableClientKey: "cfk_...",
        features: [.community]
    )
)

let result = BTX.community.present()
```

No identity call is required. The publishable client key identifies the project
and scopes a random member identifier persisted on the device. The SDK sends no
name or email. If the host later calls `BTX.identify`, Community uses that
identified customer instead.

`BTX.community.present()` returns `BTXCommunityPresentationResult`. A failed
result distinguishes disabled, unconfigured, and unavailable states. The native
sheet lets customers browse and create ideas, upvote ideas,
comment, reply once to an original comment, and like comments. The feed shows
comment counts without expanding discussions inline.

Community uses `BTXCommunityOptions` for host copy and an optional theme. When
`theme` is omitted, it inherits the same standard SDK appearance as Messenger.

See the complete
[Anonymy Community demo](https://github.com/secondcontext/btx-ios-sdk/tree/main/Examples/AnonymousCommunityDemo)
for a Community-only SwiftUI host app with anonymous members and telemetry left
off.

## Theme SDK Surfaces

Messenger, feedback, and Community sheets use untinted clear Liquid Glass over
a neutral system blur on iOS 26. Their color comes from the host content behind them;
`backgroundColor` no longer adds an opaque color wash to these floating sheets.
Older iOS versions use the system blur alone. Native materials respond to the
host appearance and system accessibility settings. Text, controls, chat bubbles,
and branding still use `BTXTheme`. Foreground notifications also default to
untinted clear glass with neutral blur; hosts can explicitly choose `.regular`
or set `foregroundNotificationMaterialOpacity` to apply their notification tint.

No theme is required. To choose a complete SDK appearance, use a preset:

```swift
let messengerOptions = BTXMessengerOptions(
    theme: .dark
)
```

For host branding, map the six semantic colors the SDK needs. The palette keeps
the Messenger and Community sheets, feedback form, bubbles, composers,
controls, links, and foreground notifications aligned automatically:

```swift
let messengerOptions = BTXMessengerOptions(
    theme: BTXTheme(
        palette: BTXThemePalette(
            background: BTXColor(red: 0.04, green: 0.05, blue: 0.06),
            surface: BTXColor(red: 0.10, green: 0.11, blue: 0.12),
            primaryText: BTXColor(red: 0.96, green: 0.97, blue: 0.98),
            secondaryText: BTXColor(red: 0.68, green: 0.70, blue: 0.72),
            accent: BTXColor(red: 0.36, green: 0.76, blue: 0.92),
            accentForeground: BTXColor(red: 0.02, green: 0.03, blue: 0.04)
        ),
        colorScheme: .dark
    )
)
```

Use the detailed `BTXTheme` initializer only for deliberate per-surface
exceptions such as custom artwork, fonts, or a special notification treatment.
Message bubble fills are flattened against the configured messenger background,
so both incoming and outgoing bubbles remain opaque over busy host content.

## Messenger Media Attachments

The messenger composer keeps attachment controls disabled until the SDK finishes negotiating attachment capabilities with the BTX messenger session. After negotiation, the composer only enables the image and video flows the backend allows for that customer session. Images remain available through paste and the native photo picker. Videos use the same picker, are validated locally against the negotiated video MIME allowlist, and are sent as BTX-managed uploads. The composer exposes one system photo-picker control and does not require full photo-library permission or an `NSPhotoLibraryUsageDescription` entry.

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
- `BTX.community`
- `BTX.featureFlags`
- `BTXFeatureFlagsState`
- `BTX.isMessengerNotification(_:)`
- `BTXConfiguration`
- `BTXCustomer`
- `BTXAppContext`
- `BTXRuntimeContext`, `BTXHostAppRuntimeContext`,
  `BTXOperatingSystemRuntimeContext`, `BTXHostDeviceRuntimeContext`,
  `BTXRuntimeEnvironmentContext`, `BTXSDKRuntimeContext`, `BTXRuntimeIdentifier`
- `BTXAppSnapshotReason`
- `BTXClientKitVersion`
- `BTXMessengerOptions`
- `BTXCommunityOptions`
- `BTXCommunityIdea`, `BTXCommunityReply`
- `BTXCommunityPresentationResult`, `BTXCommunityPresentationFailure`
- `BTXFeedbackOptions`
- `BTXPushConfiguration`
- `BTXTheme`, `BTXThemePreset`, `BTXThemePalette`, `BTXColorScheme`,
  `BTXColor`, `BTXFont`, `BTXImageResource`,
  `BTXPrimaryCTAStyle`, `BTXForegroundNotificationGlassStyle`
  - `BTXTheme.light` and `.dark` provide complete appearances. Omit the theme
    to keep the standard SDK appearance.
  - `BTXThemePalette` maps six host-brand colors across every Messenger,
    feedback, and Community surface.
  - `BTXTheme.backgroundColor` controls embedded messenger backgrounds and derived theme colors. Floating Messenger, feedback, and Community sheets use neutral blur and untinted clear glass.
  - `BTXTheme.surfaceColor` controls themed cards and neutral surfaces.
  - `BTXTheme.historyRowBackgroundColor` and `historyRowStrokeColor`
    independently theme conversation-history rows. If a requested row fill
    cannot maintain 4.5:1 contrast with both configured history text colors,
    the SDK falls back to the themed surface color.
  - `BTXTheme.emptyStateLogo` supplies shared artwork above the messenger home heading and in the new-message view. Homes without a logo omit the artwork; the new-message view uses a message symbol as its fallback.
  - `BTXTheme.emptyStateLogoMaxWidth` and `emptyStateLogoMaxHeight` constrain that logo.
  - `BTXTheme.emptyStateLogoToCTASpacing` controls the gap between the home logo and primary action.
  - `BTXTheme.primaryCTAColor` controls primary action fill.
  - `BTXTheme.primaryCTATextColor` controls primary action text and icon color.
  - `BTXTheme.primaryCTAStyle` supports `.glass` and `.solid`.
  - `BTXTheme.colorScheme` supports `.system`, `.light`, and `.dark` for hosts
    whose fixed palette must not follow the device appearance.
  - Message bubble, composer, and foreground-notification colors can be themed for light host apps. When a themed host omits the incoming bubble color, the SDK derives a subtle fill from the primary text color so operator messages remain distinct from the page background.
  - Incoming and outgoing bubble fills are rendered opaquely. Translucent host bubble colors are first composited over `backgroundColor`, preserving their intended appearance without allowing live host content to show through.
  - The standard appearance uses light customer bubbles with dark text and dark operator bubbles with light text. Explicit host bubble colors remain supported. Outgoing links use the bubble text color with an underline to remain readable against the fill.
  - The composer input uses only its Liquid Glass surface; it never adds a static outline around the interactive glass shape.
  - Foreground notifications show the replying operator's avatar when available,
    with the banner-specific logo as a compact project badge. The same logo is
    the fallback when no operator avatar is available.
- `BTXImageLoader`, `BTXImageLoadContext`
- `BTXLogInput`, `BTXLogLevel`, `BTXLogDisposition`, `BTXLogValueConvertible`, `BTXJSONValue`
- `BTXLaunchContext`, `BTXMessengerEntryPoint`, `BTXPresentationRoute`
- `BTXConversationPurpose`
- `BTXThreadIntro`, `BTXThreadIntroRow`, `BTXThreadAttributeValue`, `BTXThreadAttribute`
- `BTXConversationStarterSection`, `BTXConversationStarter`, `BTXConversationStarterProvider`

`BTXRuntime` and the old `BTXCustomerMessenger*` client/service/view/modifier paths are implementation details, not host APIs.

## Feedback Center

After `BTX.configure` and `BTX.identify` (or `BTX.identifyAnonymous`), present the
project's feedback board with `BTX.feedbackCenter.present()`. The board uses the
SDK's customer session and does not require opening the messenger.

```swift
BTXFeedbackCenterButton(session: BTX.feedbackCenter, theme: appTheme) {
    Label("Add Feedback", systemImage: "plus")
}
```

For host-owned presentation, use `BTXFeedbackCenterView(session: BTX.feedbackCenter,
theme: appTheme)` inside a sheet. Set `messengerOptions.showsFeedbackCenter = true`
to include the entry in messenger home/history. Backend availability is separately
gated by the project's `feedbackCenter` capability.

Ideas and customer comments display no participant identities. Operator replies
use **Team**. Ideas, comments, and votes appear immediately and reconcile with the
server. Submissions sync in the background; failures keep their text
in place with **Retry**, using the same request ID to prevent duplicates. Unconfirmed
submissions are session-local and do not survive app termination. The board refreshes
when opened, foregrounded, or pulled to refresh; it does not subscribe to live events.
Changing project or customer identity clears the board's local state and drafts.

### Local fixtures

Debug builds expose `BTXFeedbackCenterPreview` through
`@_spi(BTXClientKitTesting) import BTXClientKit`. Pass a retained preview to the same
view/button components for an independent in-memory board without configuring BTX.
Use `preview.reset()` or `preview.reset(empty: true)` to reset fixtures.
`messengerOptions.feedbackCenterPreview = preview` overrides the messenger entry
in debug builds. Fixture code is absent from release builds.
