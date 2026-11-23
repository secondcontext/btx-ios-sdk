# Push notifications

Receive operator reply notifications when your iOS app is not in the foreground.
For Mac apps, use the [macOS APNs adapter](macos.md#macos-reply-notifications).

Push is optional. Messenger threads and foreground live updates work without APNs.

BTX handles messenger notifications and forwards other notifications to your app’s delegate. If your SwiftUI app uses `UIApplicationDelegateAdaptor`, keep handling silent pushes in that delegate as usual.

SDK 3.8.1 quietly baselines historical unread threads on first sync. Later
eligible replies can show a single or grouped in-app banner. Dismissing or opening
a banner acknowledges its displayed replies across app restarts without marking
all threads read. Delayed or missing-ID push replays do not restore acknowledged
alerts. In SDK 3.8.2 and later, opening the thread list also acknowledges its
reply alerts while keeping threads unread. A newer reply can show a fresh banner. See
[reply alerts and unread badges](customer-messenger.md#reply-alerts-and-unread-badges).

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

## Sign-out and account changes

Unregister while the current customer identity is still active, then clear or
replace it. From an async main-actor context:

```swift
try await BTX.messenger.unregisterPushDevice()
BTX.identify(nil)
```

If unregistration fails, handle the error before clearing the identity. Do not
silently continue the account switch with the old push registration still active.

[All guides](README.md)
