# iOS quickstart

Add Customer Messenger to your app, identify a customer, and send your first
support message. You can add feedback, telemetry, and feature flags afterwards.

## Before you start

- An iOS app targeting iOS 17 or later.
- A [publishable client key](https://btx.so/docs/publishable-keys) registered for
  **iOS** and your app's exact bundle ID.
- A stable customer ID from your app's account system.

For a Mac app, use the [macOS guide](macos.md).

## 1. Add the package

In Xcode, select **File → Add Package Dependencies…**, then enter:

```text
https://github.com/secondcontext/btx-ios-sdk.git
```

Select **3.5.0 or later** and add the **BTXClientKit** product to your app target.

## 2. Configure once

Call this from your existing app startup code. Replace `cfk_...` with the
publishable key for your iOS SDK client.

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

## 3. Identify the customer

Call this after sign-in or session restoration. Use your account ID so the same
person keeps their support history across devices.

```swift
@MainActor
func identifyBTXCustomer(id: String, name: String, email: String) {
    BTX.identify(
        BTXCustomer(externalID: id, name: name, email: email)
    )
}
```

Update the identity when the signed-in account changes. If push is enabled,
follow the [sign-out lifecycle](push-notifications.md#sign-out-and-account-changes)
before clearing the customer.

## 4. Open Customer Messenger

Connect your support button or menu action to this method:

```swift
@MainActor
func openSupport() {
    BTX.messenger.present()
}
```

The SDK owns the iOS presentation. No host window modifier is required.

## 5. Verify the integration

1. Open Customer Messenger and send a message from your app.
2. Open the same project in BTX and find the customer's thread.
3. Send an operator reply and confirm it appears in the app.

Foreground messaging works without APNs. Add [push notifications](push-notifications.md)
when customers should receive replies outside the foreground app.

## Add the next feature

- [Help Center](help-center.md): let customers find answers inside your app.
- [Rage-shake feedback](feedback.md): collect an issue report from a shake gesture.
- [Telemetry](telemetry.md): attach product events and runtime context.
- [Feature flags](feature-flags.md): control a customer-targeted feature.

[All guides](README.md)
