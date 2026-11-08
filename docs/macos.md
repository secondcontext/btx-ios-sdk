# macOS integration

Use the same `BTXClientKit` package in a native SwiftUI or AppKit Mac app.
macOS requires macOS 13 or later and SDK 3.5.0 or later.

Customer Messenger, manual screenshot feedback, telemetry, and feature flags use
the shared customer runtime. Rage-shake is an iOS interaction; offer feedback from
a button or menu action on the Mac.

## Configure macOS

Call this once on the main actor during app startup. Use the publishable key
from your **macOS** SDK client:

```swift
import BTXClientKit

@MainActor
func configureBTX() {
    BTX.configure(
        BTXConfiguration(
            publishableClientKey: "cfk_...",
            features: [.messenger]
        )
    )
}
```

Identify the customer after sign-in with `BTX.identify(BTXCustomer(...))`, using
the same stable account ID as your iOS app when both apps share a customer.
The [customer identity guide](https://btx.so/docs/macos/identify-customers)
shows sign-in and sign-out handling.

## Register host windows

Configure and identify through the same `BTX` facade, with `.messenger` and
optional `.logs`. Pass the host's `BTXTheme` through `BTXMessengerOptions.theme`.
Register each SwiftUI host window once. Replace `ContentView` with your app’s
root view:

```swift
WindowGroup {
    ContentView()
        .btxMessenger()
}
```

AppKit hosts register their window with `BTX.messenger.attach(to: window)`.

## Customize native presentation

In SDK 3.6.0 and later, pass the optional Mac controls through your existing
`BTXMessengerOptions`. All have defaults.

```swift
let options = BTXMessengerOptions(
    teamDisplayName: "Acme Support",
    emptyPromptTitle: "",
    macOS: BTXMacOSMessengerOptions(
        presentation: BTXMacOSPanelPresentation(
            corner: .bottomTrailing,
            width: 440,
            height: nil,
            insets: .init(top: 90, leading: 24, bottom: 60, trailing: 24)
        ),
        panelStyle: BTXMacOSPanelStyle(
            cornerRadius: 0,
            strokeColor: BTXColor(red: 0.5, green: 0.5, blue: 0.5),
            showsShadow: false
        ),
        homeLayout: .compact
    )
)
```

The default support panel is bottom trailing, 440 by 584 points, with 16-point
insets and rounded corners. A nil height fills the available space. Oversized
panels shrink to fit. Support and reply toasts respect the insets. Feedback
uses the panel styling in a centered modal inside the host window.

In SDK 3.7.0, `BTXMacOSPanelStyle` also accepts `headerDividerColor` (nil hides
it), `primaryButtonLetterSpacing` and `threadLabelLetterSpacing` (points, default
0), `timestampFont` (optional `BTXFont`), `messageBubbleStrokeColor` (optional
1-point stroke), `composerCornerRadius` (default 16), and `composerStrokeColor`
(defaults to the theme's composer control stroke). These controls style support
and feedback where applicable. Invalid numeric values use safe defaults.
The thread count appears directly beside Threads. Team photos fall back to
customer-visible initials while loading or on failure, including members without
photos when returned by the backend. No email address is used for initials.

For a window with a changing footer, supply a per-window override. Updating the
value preserves the open thread and draft.

```swift
ContentView()
    .btxMessenger(presentation: BTXMacOSPanelPresentation(
        insets: .init(bottom: footerHeight + 16)
    ))
```

AppKit hosts can call `BTX.messenger.attach(to: window, presentation: layout)`
again when their layout changes. Calling it without presentation preserves the
existing window override.

Compact home uses a label-width action. The action and Threads header stay fixed
while rows scroll. The count describes loaded threads. Blank headings and
headings matching the action label are hidden in both layouts.

## Present support and feedback

Call either method from its own button or menu action:

```swift
BTX.messenger.presentSupport()
BTX.messenger.presentFeedbackReport(includeScreenshot: true)
```

`presentSupport()` opens support inside the registered window.
`presentFeedbackReport(includeScreenshot: true)` presents feedback with a
removable capture of that app window. Presentation returns `.failed(.unavailable)`
when no registered window can host the UI. Registration does not create another
SDK runtime or customer session.

The macOS renderer uses shared theme colors for surfaces, message bubbles,
composers, controls, links, history, and CTAs, plus body/title/hero font overrides
and light/dark/system appearance. Native Liquid Glass is available on macOS 26;
earlier supported systems use native controls. Sessions, sync, read receipts,
image uploads, reactions, and telemetry use the shared customer-app runtime.
The native iOS and macOS adapters share message ordering, optimistic sends,
failed-draft recovery, image preprocessing, rich text, and the durable feedback
outbox. Feedback confirmation means it was saved on this device for delivery;
network failures retry while the app is active and after relaunch. Preparation
or local-save failures retain the editable draft. Pending reports remain scoped
to the original API, client, and customer.

Community, Help Center, campaign UI, contextual rating sheets, video capture,
and image markup remain iOS-only. Manual text/image feedback and programmatic
feedback submission are available on macOS.

## macOS reply notifications

The macOS integration supports APNs notifications for support and feedback replies.
Configure BTX before the app finishes launching, and forward the host app's APNs
token from its existing `NSApplicationDelegate`:

```swift
import AppKit
import BTXClientKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func application(
        _ application: NSApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        BTX.messenger.setDeviceToken(deviceToken)
    }
}
```

Enable **Push Notifications** on the host app and use a matching signing profile.
The SDK reads `com.apple.developer.aps-environment` from the signed app; it does
not infer the macOS APNs environment from the build configuration. Set up a macOS
client in BTX with the same bundle ID and its APNs credentials.

The first support or feedback presentation requests notification permission by
default. Set `BTXPushConfiguration(automaticallyRequestsAuthorization: false)`
when the host owns permission timing and APNs registration. Keep the host's
registration-failure callback for diagnostics.

The SDK preserves the host notification delegate, including later replacements,
and forwards unrelated notifications and notification-settings actions. In
3.5.1 and later, with the support panel closed, replies show a toast inside a
visible registered window, even when another app has focus. A fully covered,
hidden, or minimized window can show the toast when it becomes visible again.
APNs provides native
notifications while the app is in the background. A notification click
waits for identification and a registered `.btxMessenger()` or AppKit host window,
then activates that window and opens the matching thread. Passive delivery
and dismissal do not open it. The existing `BTX.handleNotificationResponse(_:)`
and `BTX.messenger` notification forwarding APIs are also available on macOS.

Before signing out or switching customers, await
`BTX.messenger.unregisterPushDevice()` while the current identity is active,
then call `BTX.identify(nil)` or identify the next customer. The shared lifecycle
cancels stale registration tasks, replays cached tokens for the next identity,
and clears pending notification navigation from the previous identity.

Normal reply delivery and operator test pushes require production APNs
registrations.

[All guides](README.md)
