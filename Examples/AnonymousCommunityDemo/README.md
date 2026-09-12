# Anonymy Community Demo

Anonymy is a small SwiftUI reference app that shows how to add BTX Community
without requiring accounts or enabling host-app telemetry.

## Run the app

1. Copy `Configs/AnonymousCommunityDemo.local.example.xcconfig` to
   `Configs/AnonymousCommunityDemo.local.xcconfig`.
2. Replace `YOUR_PUBLISHABLE_CLIENT_KEY` with the publishable client key created
   for your iOS app. Do not put a server secret in the app.
3. Open `AnonymousCommunityDemo.xcodeproj` and run the
   `AnonymousCommunityDemo` scheme.

The complete integration is:

```swift
BTX.configure(
    BTXConfiguration(
        publishableClientKey: "YOUR_PUBLISHABLE_CLIENT_KEY",
        features: [.community]
    )
)

BTX.community.present()
```

The publishable client key is the only connection setting the SDK needs. When
the app does not call `BTX.identify`, Community automatically creates a stable
anonymous member with no name or email. Because `.logs` is not enabled, the app
does not opt in to BTX host-app telemetry.

See the [Community integration guide](https://btx.secondcontext.com/docs/ios/community)
for theming and optional identified-customer setup.
