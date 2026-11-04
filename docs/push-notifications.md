# Push notifications

Receive operator reply notifications when your iOS app is not in the foreground.
For Mac apps, use the [macOS APNs adapter](macos.md#macos-reply-notifications).

Push is optional. Messenger threads and foreground live updates work without APNs.

When the app opens or returns to the foreground, unread support replies can show
an in-app banner. Dismissing a reply or opening its conversation suppresses that
reply's banner on the device across app restarts, without depending on a successful
server read receipt. A newer reply can show a new banner. Read-state updates remove
matching visible banners; dismissal alone leaves the conversation unread.

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
