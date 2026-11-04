# Feature flags

Roll out a guided firmware update experience to selected customers.
BTX evaluates flags for the identified customer, and your app reads the result
synchronously with an explicit fallback.

## Read a flag

After [configuration and identification](quickstart.md), read a flag from the main actor:

```swift
let useGuidedUpdater = BTX.featureFlags.isEnabled(
    "firmware-update-v2.enabled",
    fallback: false
)
```

The SDK returns the fallback until an evaluation is available or when the key is
unknown. Choose a fallback that keeps your app usable without a network response.

## Choose which updater opens

Pass your app’s existing update flows into this SwiftUI entry point. Observing
the shared flag object updates the button when evaluations change:

```swift
import SwiftUI
import BTXClientKit

struct FirmwareUpdateEntry: View {
    @ObservedObject private var flags = BTX.featureFlags
    let startGuidedUpdate: () -> Void
    let startStandardUpdate: () -> Void

    var body: some View {
        let guided = flags.isEnabled("firmware-update-v2.enabled", fallback: false)

        Button(guided ? "Update with guide" : "Update firmware",
               systemImage: "arrow.down.circle") {
            if guided {
                startGuidedUpdate()
            } else {
                startStandardUpdate()
            }
        }
    }
}
```

Keep the same battery, connection, and firmware compatibility checks in both
update flows. The flag selects the experience; your app still owns the update.

For a host-owned model, use `BTX.featureFlags.onChange { state in ... }` and retain
the returned cancellable for as long as you want updates.

## Refresh explicitly

Flags refresh through the shared runtime. When you need a fresh evaluation,
call this from an async main-actor context and handle transport errors:

```swift
let state = try await BTX.featureFlags.refresh()
```

Flag state returns to `.unloaded` when the configuration or customer identity
changes, so a previous customer's evaluation does not become the next customer's result.

[All guides](README.md)
