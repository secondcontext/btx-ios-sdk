# Hardware telemetry

Help your team distinguish a low-battery device, a Bluetooth connection failure,
and a failed firmware update. Combine current device health with the events that
explain how the device reached that state.

## Choose a recipe

| Question | Guide |
| --- | --- |
| What is the device's current battery, charging, and firmware state? | [Device health](device-health.md) |
| Where did the connection fail, and did a retry recover it? | [Connection diagnostics](connection-diagnostics.md) |
| Which update failed, at what stage, and which version is actually installed? | [Firmware update diagnostics](firmware-update-diagnostics.md) |

## Before you start

Enable `.logs` and identify the customer, as shown in [telemetry](telemetry.md).
The recipes use the existing SDK 3.5.0 APIs and work with iOS and macOS hosts.
The Swift helper functions in these guides are app code you can adapt; they are
not additional BTX APIs.

Your app reads hardware state through its device integration and reports
connection and update outcomes. BTX provides snapshot reporting, structured logs,
and app context. It does not inspect Bluetooth traffic or run firmware updates.

## Keep device identity consistent

Use the same vendor hardware ID, such as `ring_123`, in snapshots, event
`deviceId` properties, and [support context](customer-messenger.md#open-support-from-a-device-error).
A snapshot's first identifier is its primary identity; additional identifiers are
aliases. A vendor hardware ID or serial number is preferable to a Core Bluetooth
peripheral UUID, which is scoped to the observing Apple device and customer.

The snapshot reporter's `connectionKey` stays local and is never transmitted.
Do not use it as a substitute for your physical device ID in diagnostic events.

Standard health fields appear in Devices when that feature is enabled for the
workspace. Charging state, custom readings, connection stages, and update details
are available in expanded telemetry event JSON. Diagnostic IDs support event
search; they do not create automatic connection or firmware-update dashboards.

Keep event names and property types consistent. The names in these recipes are
suggested host events, not events BTX automatically generates. Log transitions
and outcomes rather than every packet, RSSI change, or transfer progress tick.

[Telemetry](telemetry.md) · [All guides](README.md)
