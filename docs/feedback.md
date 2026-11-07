# Rage-shake feedback

Let customers report a pairing failure, stalled sync, or confusing device screen
while it is happening. A deliberate shake opens
a feedback prompt; the customer can describe the problem and review a screenshot
before sending it.

Rage-shake is available on iOS. Mac apps can open the same kind of
[feedback report from a button or menu action](macos.md#present-support-and-feedback).

Camera capture requires `NSCameraUsageDescription` in the host app’s Info.plist. The camera button requests permission on first use. If access is denied, the customer can enable it in Settings; devices without a camera can still attach library media. Captured photos use the same attachment limits, previews, and image processing as library photos.

## Enable rage-shake

After the [quickstart](quickstart.md), add the feedback options to your existing
startup configuration. Automatic feedback triggers are off by default.

```swift
BTX.configure(
    BTXConfiguration(
        publishableClientKey: "cfk_...",
        features: [.messenger],
        messengerOptions: BTXMessengerOptions(
            feedback: BTXFeedbackOptions(
                onShake: .enabled(includeScreenCapture: true)
            )
        )
    )
)
```

Run configuration on the main actor, then identify the customer after sign-in.
Set `includeScreenCapture: false` if your app should open the flow without
capturing the active app window.

## What the customer sees

1. A deliberate shake opens a compact confirmation prompt.
2. Continuing opens the feedback composer with the optional screenshot.
3. The customer can edit the screenshot, remove it, attach media, take a camera photo, and describe the issue.
4. **Send** saves the report on the device and closes the composer.

Captured media stays local until the customer sends the report. Dismissing the
composer discards the draft. The SDK retries saved reports while the app is active
and after relaunch; local acceptance is separate from successful server delivery.

The report becomes a replyable feedback thread in BTX. Operator replies use the
same [Customer Messenger](customer-messenger.md) and [push lifecycle](push-notifications.md).

## Open feedback from a button

Offer a visible feedback action alongside the shake gesture:

```swift
BTX.messenger.presentFeedbackReport(includeScreenshot: true)
```

Call it on the main actor after identifying the customer.

## Let the customer turn shaking off

Use the SDK's observable preference in your SwiftUI settings:

```swift
import SwiftUI
import BTXClientKit

struct FeedbackSettings: View {
    @ObservedObject private var preferences = BTX.feedbackPreferences

    var body: some View {
        Toggle("Shake to send feedback", isOn: $preferences.isShakeEnabled)
    }
}
```

The preference persists on this installation. Turning it off stops shake
monitoring; manual feedback remains available.

## Test the flow

Use **Device → Shake** in Simulator to test presentation. Also test a deliberate
shake on a physical iPhone; Simulator does not exercise accelerometer detection.

For screenshot triggers, image handling, contextual ratings, and detection
behavior, see [advanced feedback](advanced-feedback.md).

[All guides](README.md)
