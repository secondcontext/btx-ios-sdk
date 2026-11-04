# Device health

Give your support team the device state needed to investigate a report: battery
level and health, charging state, firmware, hardware revision, and product-specific
diagnostics such as calibration status.

Complete the [telemetry setup](telemetry.md#enable-telemetry) first. Your app
supplies values from its hardware integration; BTX does not measure them.

## Report a health snapshot

Call this helper on the main actor after reading the device's characteristics,
and again when a reported value changes. Adapt the sample manufacturer, model,
and identifier namespace to your product.

```swift
import Foundation
import BTXClientKit

@MainActor
func reportDeviceHealth(
    peripheralID: UUID,
    hardwareID: String,
    firmwareVersion: String,
    batteryPercent: Double?,
    batteryHealthPercent: Double?,
    isCharging: Bool?,
    hardwareVersion: String? = nil,
    attributes: [String: BTXJSONValue] = [:]
) {
    BTX.deviceSnapshots.refresh(connectionKey: peripheralID.uuidString) {
        BTXDeviceSnapshot(
            identifier: .vendorHardwareID(
                hardwareID,
                namespace: "mithril.hardware_id"
            ),
            additionalIdentifiers: [
                .coreBluetoothPeripheralUUID(peripheralID)
            ],
            manufacturer: "Mithril Wearables",
            category: "wearable",
            model: "Mithril One",
            firmwareVersion: firmwareVersion,
            hardwareVersion: hardwareVersion,
            batteryPercent: batteryPercent,
            batteryHealthPercent: batteryHealthPercent,
            isCharging: isCharging,
            attributes: attributes
        )
    }
}
```

Use `nil` for readings the device does not expose. Unknown battery health is not
zero battery health. Battery fields use a 0–100 scale.

The vendor hardware ID is the physical device identity. The peripheral UUID is
an additional scoped alias. Use the same hardware ID in connection and update
events so your team can relate them to this snapshot.

## Add product-specific diagnostics

Pass known values through the helper's `attributes` parameter. `BTXJSONValue`
represents a JSON value: use `.string`, `.number`, or `.bool` for simple readings,
and `.array` or `.object` for structured values. For example:

```swift
let hardwareAttributes: [String: BTXJSONValue] = [
    "calibrationStatus": .string("needs_calibration"),
    "availableStorageBytes": .number(4_194_304)
]
```

These are sample values. Replace them with real device readings, and omit
unavailable attributes. Use stable keys, documented units, and a small set of
status values. Avoid raw characteristic dumps or constantly changing values
such as a live packet counter.

## End the connection lifecycle

When your device manager reports a disconnect, cancel pending snapshot work:

```swift
@MainActor
func stopReportingDevice(peripheralID: UUID) {
    BTX.deviceSnapshots.disconnect(connectionKey: peripheralID.uuidString)
}
```

This stops reporting for that connection; it does not emit a disconnected event.
Use a host event when you need a disconnect in the diagnostic timeline. A later
refresh starts a new connection lifecycle.

BTX coalesces rapid refreshes with a default 750 ms delay, skips unchanged
snapshots, and reports active devices again after the customer or project context
changes. Your app still calls `refresh` when hardware state changes.

## Review in BTX

In workspaces with Devices enabled, the device detail shows firmware, hardware
revision, battery level, and battery health. Those fields come from the reported
snapshot; they are not measurements BTX takes from the hardware.

For charging state and custom readings, open the customer's Telemetry, expand a
`device.snapshot` event, and inspect `device.isCharging` and `device.attributes`
in its JSON details. Charging and custom attributes do not currently have
separate fields in the Devices view.

## Verify the integration

1. Connect a device and report its current readings.
2. Change one known value, such as charging state, and report again.
3. Check the customer's telemetry for the device snapshot and updated value.
4. Repeat an unchanged reading and confirm it does not create duplicate snapshots.

[Connection diagnostics](connection-diagnostics.md) · [Hardware telemetry](device-telemetry.md) · [All guides](README.md)
