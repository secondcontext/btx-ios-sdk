# Advanced feedback

Enable [rage-shake feedback](feedback.md) first. Use these options when your app
also needs screenshot triggers, contextual ratings, or specific media behavior.

## Screenshot triggers

Set `onScreenshot: .enabled` in `BTXFeedbackOptions` to notice a user screenshot.
When the app becomes active and no messenger surface is open, the SDK can show
“Send feedback about this screen?”. Accepting opens the feedback composer with
a removable capture of the app window.

## Attachments and delivery

Customers can type or attach negotiated photo and video media from the system
Photo picker, preview and remove attachments before sending, and submit
attachment-only feedback. Opening an attached image starts the photo editor.
BTXClientKit 3.4.0 adds drag-to-cover mosaic regions and a crop frame with
adjustable corners alongside the red marker. Undo and redo cover all three
tools. Done replaces the draft with a flattened JPEG; Cancel preserves the
original draft and confirms before discarding edits. The editor uses native
Liquid Glass controls on iOS 26 and standard controls on earlier versions.
No host configuration or API changes are required.
Image markup and resilient background delivery require `BTXClientKit 3.1.0`
or later.
Captured and selected media stays local and uploads only after Send; dismissing
the prompt or composer discards it. Capture failure never opens an empty
screenshot prompt, while shake and manual capture failures still fall back to
the normal composer.

Send durably saves the report on the device, closes the composer without a
network spinner, and delivers it in the background while the app is active. If
the device is offline or delivery fails, the SDK retries during the session and
the next time the configured app becomes active. Pending reports are isolated
to the configured project and identified customer. Successful delivery creates
a normal customer-message thread without opening the full messenger sheet. The
SDK marks that thread with `BTXConversationPurpose.feedback`, so BTX operator
surfaces can distinguish it from a support request while keeping it replyable.

## Ask about a firmware update

Use one stable update-session ID so a rating change and follow-up comments stay
in the same feedback thread. Replace these sample IDs with your app’s update
session and device IDs.

Use `submitFeedback(...)` for a positive rating, or open the composer when the
customer wants to explain a problem. These are alternative UI actions; the
example shows how a later negative rating can refer to a previous positive one.

```swift
let updateFeedback = BTXLaunchContext(
    conversationPurpose: .feedback,
    entryPoint: "firmware_update_complete",
    sourceType: "firmware_update",
    sourceID: "update_456",
    threadTitle: "Firmware update feedback",
    threadAttributes: [
        "device": [
            "id": .string("ring_123"),
            "firmwareVersion": .string("2.3.7")
        ]
    ]
)

let prompt = BTXFeedbackPrompt(
    subject: "Firmware update",
    question: "What went wrong during the update?",
    choices: ["Update stalled", "Device disconnected", "Unclear instructions"]
)

await BTX.messenger.submitFeedback(
    rating: .positive,
    subject: "Firmware update",
    launchContext: updateFeedback
)

BTX.messenger.presentFeedbackReport(
    rating: .negative,
    previousRating: .positive,
    prompt: prompt,
    launchContext: updateFeedback
)
```

## Shake detection

Physical devices use Core Motion user acceleration, excluding gravity. BTX
requires four alternating impulses above 2.2 g within 0.85 seconds, spanning at
least 0.3 seconds, with a 2-second cooldown. It ignores the first 1.5 seconds of
motion after activation and resets after sensor interruptions. Motion sampling
stops while inactive or SDK UI is open. These are BTX tuning values, not an iOS
standard; validate deliberate shaking, walking, opening the app and setting the
phone down on physical devices before release. Simulator's Device > Shake tests
the presentation flow and bypasses accelerometer classification.

[All guides](README.md)
