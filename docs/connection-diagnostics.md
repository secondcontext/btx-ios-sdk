# Connection diagnostics

Record where a connection attempt failed and whether a retry reached a usable
state. This helps distinguish a device that cannot be found from one that
connects but never finishes service discovery or notification setup.

Complete the [telemetry setup](telemetry.md#enable-telemetry) first. Call the
helpers below from your connection manager's existing callbacks. BTX does not
observe Core Bluetooth callbacks automatically.

## Define one attempt

Create a `UUID` when your app begins connecting. Keep that `attemptID` through
scanning, connecting, discovery, notification setup, and any automatic retries.
A new customer-initiated attempt gets a new ID.

Use a monotonic timer in your connection manager to measure total `durationMs`.
`retryCount` is the number of retries after the initial try, so the first try is
zero. Use the physical device's hardware ID as `deviceId`.

## Record a failed attempt

Report a failure after your connection manager exhausts its retry policy or
stops the attempt. Use a stable stage such as `scanning`, `connecting`,
`service_discovery`, or `notification_setup`, and a stable error code such as
`connection_timeout` or `required_service_missing`.

```swift
import Foundation
import BTXClientKit

func recordConnectionFailure(
    deviceID: String,
    attemptID: UUID,
    stage: String,
    durationMs: Int,
    retryCount: Int,
    errorCode: String
) {
    BTX.log(
        "device_connection_failed",
        level: .warning,
        properties: [
            "deviceId": deviceID,
            "attemptID": attemptID.uuidString,
            "transport": "bluetooth",
            "connectionStage": stage,
            "durationMs": durationMs,
            "retryCount": retryCount,
            "errorCode": errorCode
        ]
    )
}
```

The sample treats an exhausted connection attempt as a warning. Your app owns
severity; adjust it to match the effect on your product. Do not log an expected
customer cancellation as an error or pass arbitrary error descriptions.

## Record a ready connection

A Bluetooth connection alone may not be usable. Record readiness after the
services and subscriptions your app requires are available:

```swift
func recordConnectionReady(
    deviceID: String,
    attemptID: UUID,
    durationMs: Int,
    retryCount: Int
) {
    BTX.log(
        "device_connection_ready",
        properties: [
            "deviceId": deviceID,
            "attemptID": attemptID.uuidString,
            "transport": "bluetooth",
            "connectionStage": "ready",
            "durationMs": durationMs,
            "retryCount": retryCount
        ]
    )
}
```

The same property names make outcomes comparable. A successful connection with
`retryCount: 2` shows recovery after two retries without reporting each radio
callback. If you need intermediate events, emit one per stage transition using
the same `deviceId` and `attemptID`.

After readiness, report a [device health snapshot](device-health.md). If the
connection later drops, call `BTX.deviceSnapshots.disconnect(connectionKey:)`
on the main actor and report a host disconnect event if your team needs that
transition in the timeline.

## Review in BTX

Search Telemetry for the hardware ID or an `attemptID` value. Expand an event to
see its stage, elapsed time, retry count, and error code. The `deviceId` property
also provides a device reference in telemetry views that support device navigation.

These are custom diagnostic events. Their IDs let your team relate events through
search and JSON details; BTX does not automatically assemble them into a connection
trace. Report snapshots separately when device state changes.

## Verify the integration

1. Cause a discovery failure and confirm its stage, error code, and elapsed time.
2. Run an attempt that recovers after a retry and confirm its ready event and count.
3. Check that events for one attempt share the same device and attempt IDs.
4. Start a new attempt and confirm it receives a new ID.

`BTX.log(...)` confirms local queuing, not server delivery. See
[telemetry delivery behavior](telemetry.md#record-a-connection-failure).

[Device health](device-health.md) · [Hardware telemetry](device-telemetry.md) · [All guides](README.md)
