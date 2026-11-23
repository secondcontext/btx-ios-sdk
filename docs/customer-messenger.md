# Customer Messenger

Give customers a native place to ask for help inside your app. Your team replies
from BTX, and the customer can return to the same thread.

Complete the [quickstart](quickstart.md) and identify the customer before opening
support. The examples in this guide run on the main actor.

## Open support

```swift
BTX.messenger.present()
```

Messenger replies render the server's validated rich-text payload for bold,
italic, underline, links, bulleted lists, and numbered lists. The SDK only uses
the formatted payload when it reproduces the exact plain message body; invalid,
unsafe, or mismatched payloads fall back to the existing plain-text renderer.
Copy actions and notification previews continue to use the plain body.

In `BTXClientKit 3.2.1` and later, projects with the delayed response message
enabled show the project's configured note when the customer's latest message
remains unanswered for the configured delay. The note stays local to the
conversation UI and is removed as soon as an operator reply arrives. Project
administrators control the enabled state, message, and delay in BTX; no host-app
configuration is required.

## Reply alerts and unread badges

In SDK 3.8.1, the first successful history sync quietly restores existing unread
threads. Later eligible replies show an in-app banner while the app is active
and Messenger is closed. One thread shows its sender and reply preview; multiple
threads show one grouped alert. Opening a grouped alert opens the unread-first
thread list without marking every thread read. Opening a single alert opens that
thread. Existing threads include a back button to return to the list.

Closing or opening a banner acknowledges every reply represented by that banner
on this installation, including across app restarts. Dismissal leaves threads
unread. A newer reply can trigger a fresh banner; older or missing-ID push
replays cannot undo that acknowledgement. The first-sync baseline is scoped to
the identified customer on this installation.

In SDK 3.8.2 and later, opening the thread list from any entry point also
acknowledges its reply alerts. Replies loaded while that list is visible are
acknowledged too. This keeps the banner dismissed across app restarts without
marking those threads read; unread badges remain until the threads are read.

`BTX.messenger.unreadCount` counts unread threads, including threads whose banners
were dismissed. Use it to show a badge on your Support control and hide the badge
when the count is zero. The banner count includes only eligible unacknowledged
threads, so it can differ from the badge. Reading a thread reduces the badge.

## Open support from a device error

When pairing or reconnection fails, include the affected device and its current
state so the customer does not need to describe their setup again.

The example uses sample values from Mithril Wearables. Replace them with state
from your connection manager; use the same device ID as your telemetry events.

```swift
BTX.messenger.present(
    route: .compose(
        launchContext: BTXLaunchContext(
            conversationPurpose: .support,
            entryPoint: "device_connection_error",
            sourceType: "device",
            sourceID: "ring_123",
            threadTitle: "Mithril One connection",
            threadIntro: .card(
                kind: "device",
                title: "Mithril One",
                subtitle: "Connection issue",
                rows: [
                    BTXThreadIntroRow(label: "Firmware", value: "2.3.7"),
                    BTXThreadIntroRow(label: "Battery", value: "42%"),
                    BTXThreadIntroRow(label: "Connection", value: "Disconnected")
                ]
            ),
            threadAttributes: [
                "device": [
                    "id": .string("ring_123"),
                    "model": .string("Mithril One"),
                    "firmwareVersion": .string("2.3.7")
                ]
            ]
        )
    )
)
```

## Attachments

The composer negotiates attachment capabilities with the BTX session before
enabling attachment controls. It enables only the image and video formats
allowed for that customer session.

- Images use paste or the native photo picker.
- Videos use the same picker, are validated against the negotiated MIME
  allowlist, and upload through BTX.
- The system picker does not require full photo-library permission or an
  `NSPhotoLibraryUsageDescription` entry.

## Match your app

Use [theming](theming.md) to choose colors, typography, and branding. Add
[push notifications](push-notifications.md) for operator replies while the app is inactive.

For issue reports triggered by a shake gesture, use [rage-shake feedback](feedback.md).

[All guides](README.md)
