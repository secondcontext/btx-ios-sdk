# Firmware update diagnostics

Connect an update's starting state, failure stage, and verified result. A completed
file transfer does not prove the device is running the requested firmware.

Complete the [telemetry setup](telemetry.md#enable-telemetry) first. Call these
helpers from your app's existing update workflow. Your app owns compatibility
checks, battery requirements, transfer, retries, and recovery.

## Record the start

Create a `UUID` when an update begins. Keep the same `updateID` through transfer,
reboot, reconnect, verification, and automatic retries. Start a new ID for a new
customer-initiated update. Keep the physical device's `deviceId` consistent with
its [health snapshot](device-health.md).

Call this helper after your app's preflight checks pass and the update starts:

```swift
import Foundation
import BTXClientKit

func recordFirmwareUpdateStarted(
    deviceID: String,
    updateID: UUID,
    fromVersion: String,
    targetVersion: String,
    batteryPercent: Double?
) {
    BTX.log(
        "firmware_update_started",
        properties: [
            "deviceId": deviceID,
            "updateID": updateID.uuidString,
            "fromVersion": fromVersion,
            "targetVersion": targetVersion,
            "batteryPercent": batteryPercent
        ]
    )
}
```

Use real source and target versions from your updater. Pass `nil` when a battery
reading is unavailable. Measure elapsed time with a monotonic timer in the host.

## Record a failed update

Report the final failure after your updater stops or exhausts its retry policy.
Use a stable stage such as `transfer`, `reboot`, `reconnect`, or `verification`.
Keep `errorCode` bounded, for example `transfer_timeout` or `device_disconnected`.

```swift
func recordFirmwareUpdateFailure(
    deviceID: String,
    updateID: UUID,
    targetVersion: String,
    stage: String,
    durationMs: Int,
    retryCount: Int,
    errorCode: String
) {
    BTX.log(
        "firmware_update_failed",
        level: .error,
        properties: [
            "deviceId": deviceID,
            "updateID": updateID.uuidString,
            "targetVersion": targetVersion,
            "updateStage": stage,
            "durationMs": durationMs,
            "retryCount": retryCount,
            "errorCode": errorCode
        ]
    )
}
```

Intermediate progress can remain in your update UI. If diagnostic milestones
are needed, log stage transitions with the same IDs rather than every chunk or
percentage change. A recovered retry is not a separate terminal failure.

## Verify the installed version

After the device reboots and reconnects, read its firmware version from the
device. This helper records success only when the reported version matches the
target. A mismatch records a failed verification:

```swift
func recordFirmwareUpdateVerification(
    deviceID: String,
    updateID: UUID,
    targetVersion: String,
    reportedVersion: String,
    durationMs: Int,
    retryCount: Int
) {
    let verified = reportedVersion == targetVersion

    BTX.log(
        verified ? "firmware_update_completed" : "firmware_update_failed",
        level: verified ? .info : .error,
        properties: [
            "deviceId": deviceID,
            "updateID": updateID.uuidString,
            "targetVersion": targetVersion,
            "reportedVersion": reportedVersion,
            "updateStage": "verification",
            "durationMs": durationMs,
            "retryCount": retryCount,
            "versionVerified": verified
        ]
    )
}
```

If your updater normalizes version strings, compare the normalized values. If
the device never reconnects or its version cannot be read, use the failure helper
with the appropriate stage and error code; do not invent a reported version.

Record one terminal outcome for an update: either the failure helper or the
verification helper. After reading the device, refresh its health snapshot with
the version it actually reports. The telemetry result does not replace your
app's update or recovery state.

## Review in BTX

Search Telemetry for an `updateID` value to find the update's start and outcome.
Expand an event to inspect its target, failure stage, retry count, or reported
version. Search by `deviceId` to review update events alongside that device's
snapshots.

These are custom diagnostic events displayed in the existing telemetry view.
BTX does not automatically turn them into firmware rollout groups, an update
progress screen, or success-rate charts. Refresh snapshots separately to update
the device's displayed firmware version.

## Verify the integration

1. Complete an update and confirm its start and verified result share the same IDs.
2. Interrupt a transfer and confirm the final failure has the stage and retry count.
3. Simulate a version mismatch and confirm it records failed verification.
4. Refresh the device snapshot and check it contains the actual installed version.

Use [feature flags](feature-flags.md) to control an updater experience if needed;
keep the same compatibility and device-health checks in every update path.

[Device health](device-health.md) · [Hardware telemetry](device-telemetry.md) · [All guides](README.md)
