# Telemetry

Connect a customer’s support report with their device’s connection, sync, and
firmware history. Use the same customer identity as Customer Messenger.

## Enable telemetry

Add `.logs` to your existing startup feature set. Telemetry is opt-in.

```swift
BTXConfiguration(
    publishableClientKey: "cfk_...",
    features: [.messenger, .logs]
)
```

Pass this configuration to `BTX.configure(...)` on the main actor. Identify the
customer after sign-in, as shown in the [quickstart](quickstart.md).

## Record a connection failure

Log the outcome from your connection manager or Core Bluetooth callback. The
values below are sample device state; replace them with the state from your app.

```swift
BTX.log(
    "device_connection_failed",
    properties: [
        "deviceID": "ring_123",
        "deviceModel": "Mithril One",
        "firmwareVersion": "2.3.7",
        "transport": "bluetooth",
        "connectionStage": "service_discovery",
        "errorCode": "connection_timeout",
        "retryCount": 2
    ]
)
```

`BTX.log(...)` accepts the event immediately and sends it later. Its `.enqueued`
result confirms local queuing, not server delivery. The SDK buffers events until
configuration, identity, and transport are ready.

## Record a completed device sync

Log the duration and outcome when a sync finishes:

```swift
BTX.log(
    "device_sync_completed",
    properties: [
        "deviceID": "ring_123",
        "firmwareVersion": "2.3.7",
        "batteryPercent": 42,
        "durationMs": 1400,
        "recordsSynced": 24
    ]
)
```

Use the same device ID in support context and telemetry so your team can connect
the report to that device. For firmware updates, use events such as
`firmware_update_started`, `firmware_update_completed`, and `firmware_update_failed`,
with the current version, target version, and failure reason when available.

Properties support strings, integers, doubles, booleans, `nil`, arrays,
dictionaries keyed by `String`, and explicit `BTXJSONValue` values.

## Automatic app context

When logs are enabled, BTX records an `app.snapshot` event with privacy-safe app,
operating system, device family, architecture, Simulator, and SDK version context.
It excludes advertising identifiers, `identifierForVendor`, the user-assigned
device name, and stable personal device identifiers.

Use `BTXAppContext.current()` when you need the standardized snapshot directly.
You can supply explicit app version fields through `BTXConfiguration.appContext`.

## Keep events useful

- Log state transitions and outcomes, such as connection failures and completed syncs.
- Keep event names and property shapes stable.
- Avoid emitting a log for every RSSI update or transferred packet.
- Prefer product IDs and bounded values over free-form data dumps.
- Keep credentials, access tokens, and pairing secrets out of events.

For apps that integrate physical hardware, see [hardware telemetry](device-telemetry.md).

[All guides](README.md)
