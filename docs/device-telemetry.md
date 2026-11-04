# Hardware telemetry

Attach hardware context to a customer’s diagnostic history when your app
connects to a physical device. The example uses your app’s `peripheral` and
`ring` models.

Hosts only map their hardware-specific state into `BTXDeviceSnapshot`. The SDK owns
coalescing, deduplication, lifecycle reasons, disconnect cancellation, and re-reporting
an active device after the identified customer or BTX project changes.

```swift
BTX.deviceSnapshots.refresh(
    connectionKey: peripheral.identifier.uuidString
) {
    BTXDeviceSnapshot(
        identifiers: [
            .vendorHardwareID(
                ring.hardwareID,
                namespace: "mithril.hardware_id"
            ),
            .serialNumber(
                ring.serialNumber,
                namespace: "mithril.serial_number"
            ),
            .coreBluetoothPeripheralUUID(peripheral.identifier),
        ],
        manufacturer: "Mithril Wearables",
        category: "wearable",
        model: ring.model,
        firmwareVersion: ring.firmwareVersion,
        batteryPercent: ring.batteryPercent
    )
}
```

The `connectionKey` stays local to the SDK and is never transmitted. Call
`BTX.deviceSnapshots.disconnect(connectionKey:)` when that hardware connection ends.
Never put pairing secrets, ownership tokens, or credentials in a device identifier.

[Telemetry](telemetry.md) · [All guides](README.md)
