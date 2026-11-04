# Integration examples

Choose one configuration below. Replace `cfk_...` with your publishable key,
then connect the functions to your app’s startup, sign-in, and device callbacks.
Each example uses standard Swift types and runs on the main actor.

## Telemetry only

Call `configureBTX()` once at startup, identify after sign-in, and call
`trackConnectionFailed(...)` from your connection manager when an attempt fails.

```swift
import BTXClientKit

@MainActor
func configureBTX() {
    BTX.configure(
        BTXConfiguration(
            publishableClientKey: "cfk_...",
            features: [.logs]
        )
    )
}

@MainActor
func identifyBTXCustomer(id: String, name: String, email: String) {
    BTX.identify(
        BTXCustomer(
            externalID: id,
            name: name,
            email: email
        )
    )
}

@MainActor
func trackConnectionFailed(deviceID: String, firmwareVersion: String) {
    BTX.log(
        "device_connection_failed",
        properties: [
            "deviceID": deviceID,
            "firmwareVersion": firmwareVersion
        ]
    )
}
```

## Customer Messenger only

Configure once at startup and identify after sign-in. Connect `openSupport()`
to your app’s support button.

```swift
import BTXClientKit

@MainActor
func configureBTX() {
    BTX.configure(
        BTXConfiguration(
            publishableClientKey: "cfk_...",
            features: [.messenger],
            messengerOptions: BTXMessengerOptions(
                title: "Support",
                teamDisplayName: "Support Team"
            )
        )
    )
}

@MainActor
func identifyBTXCustomer(id: String, name: String, email: String) {
    BTX.identify(
        BTXCustomer(
            externalID: id,
            name: name,
            email: email
        )
    )
}

@MainActor
func openSupport() {
    BTX.messenger.present()
}
```

## Customer Messenger and telemetry

Use this configuration when support threads and device events should share the
same customer identity. Pass the affected device’s ID and firmware version from
your connection manager.

```swift
import BTXClientKit

@MainActor
func configureBTX() {
    BTX.configure(
        BTXConfiguration(
            publishableClientKey: "cfk_...",
            features: [.logs, .messenger],
            messengerOptions: BTXMessengerOptions(
                title: "Support",
                teamDisplayName: "Support Team"
            )
        )
    )
}

@MainActor
func identifyBTXCustomer(id: String, name: String, email: String) {
    BTX.identify(BTXCustomer(externalID: id, name: name, email: email))
}

@MainActor
func trackConnectionFailed(deviceID: String, firmwareVersion: String) {
    BTX.log(
        "device_connection_failed",
        properties: [
            "deviceID": deviceID,
            "firmwareVersion": firmwareVersion
        ]
    )
}

@MainActor
func openSupport() {
    BTX.messenger.present()
}
```

[All guides](README.md)
