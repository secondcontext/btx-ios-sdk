# Additional features

These optional iOS features build on the same BTX configuration and customer
identity. Start with the [core guides](README.md#core-features) before adding them.

## Present Community

Enable `.community`, then connect the host app's Community entry point to:

```swift
BTX.configure(
    BTXConfiguration(
        publishableClientKey: "cfk_...",
        features: [.community]
    )
)

let result = BTX.community.present()
```

Use `BTXCommunityCenter.systemImageName` for the entry point icon. It returns
the canonical `heart` SF Symbol so Community has a consistent identity across
host apps.

No identity call is required. The publishable client key identifies the project
and scopes a random member identifier persisted on the device. The SDK sends no
name or email. If the host later calls `BTX.identify`, Community uses that
identified customer instead.

`BTX.community.present()` returns `BTXCommunityPresentationResult`. A failed
result distinguishes disabled, unconfigured, and unavailable states. The native
sheet lets customers browse and create ideas, upvote ideas,
comment, reply once to an original comment, and like comments. The feed shows
comment counts without expanding discussions inline.

Community uses `BTXCommunityOptions` for host copy and an optional theme. When
`theme` is omitted, it inherits the same standard SDK appearance as Messenger.

See the complete
[Anonymous Community demo](https://github.com/secondcontext/btx-ios-sdk/tree/main/Examples/AnonymousCommunityDemo)
for a Community-only SwiftUI host app with anonymous members and telemetry left
off.

## In-app campaigns

Show targeted announcements as native cards, banners, and full-image campaigns. Customers can open an
HTTPS link or a public Help Center article from a campaign. Help Center actions
require `.helpCenter`.

In-app campaigns require BTXClientKit 3.3.1 or later and campaign access for your
project. Check [GitHub Releases](https://github.com/secondcontext/btx-ios-sdk/releases)
for available SDK versions.

Image campaigns require 3.8.0 or later. They fill a 5:8 frame using the crop set
in BTX. Tapping the image opens the campaign action. The top-right close button
dismisses the campaign. Earlier SDK versions skip Image deliveries.

Add `.inAppCampaigns` to your configuration and identify the signed-in customer:

```swift
BTX.configure(BTXConfiguration(
    publishableClientKey: "cfk_...",
    features: [.inAppCampaigns, .helpCenter],
    inAppCampaignOptions: BTXInAppCampaignOptions(theme: appTheme)
))
BTX.identify(BTXCustomer(externalID: user.id))

// After sign-in is confirmed and the app screen is ready:
BTX.inAppCampaigns.setPresentationReady(true)
```

Presentation defaults to disabled on each launch. The SDK waits two seconds after
readiness and checks for an active window without a modal, keyboard, or another
SDK presentation. Anonymous identities cannot receive campaigns. Repeated `true`
calls do not restart the delay. Visible campaigns yield when the host opens a modal,
starts text entry, begins a navigation transition, or becomes inactive. Host UI keeps priority.
Changing accounts or the publishable client key
resets readiness; updating the same customer's profile does not.

Before sign-out or account switching, cancel pending presentation, dismiss visible
campaigns, and clear the identity:

```swift
BTX.inAppCampaigns.setPresentationReady(false)
BTX.identify(nil)
```

The SDK automatically attempts at most one campaign when the app launches
and each time it returns from the background. On return, it waits two seconds and
requires host readiness and a safe active window. An internet connection is required. Active campaigns are considered in queue order;
paused campaigns keep their position when resumed. Content edits apply to pending
deliveries. An app that has already reserved content for display keeps that version.
If an edit invalidates the app's pending content, presentation waits until a later
launch or return from the background. Campaign interactions are saved across restarts and sent when connectivity
is available. An uncertain presentation is not repeated.

Tapping a campaign notification opens that campaign after the app is ready, including
when returning from the background. The SDK checks the signed-in customer's eligibility
and loads the current content. Paused, archived, or already-viewed campaigns do not open.
Notification taps do not advance the automatic campaign queue or execute the card's action.

Campaigns inherit `messengerOptions.theme` unless you provide
`BTXInAppCampaignOptions(theme:)`. Cards use `titleFont` and `bodyFont`.
Banners share support notifications’ typography: `bodyFont` at 15 points semibold
for titles and 13 points medium for message text. Banners without an action link
remain fully legible and expose no action button.
On iOS 26 and later, cards and banners use `foregroundNotificationGlassStyle`
(`.clear` by default or `.regular`). Clear glass uses the shared SDK blur layer
to keep content readable over the host screen. Campaigns also honor the foreground
notification background, material opacity, and stroke settings. Card background
dimming is separate from the glass style.
Card actions also use `titleFont` and the Messenger primary CTA colors and style.
Register custom fonts in your app before using them. Banner bodies show at most
two lines; tapping the content opens the action, and the close button dismisses it.

Campaigns prepare artwork before appearing, so images and text display
together. Banners use the project logo when no custom artwork is set. If artwork
cannot be loaded, the campaign stays hidden and can retry on a later launch or
return from the background. Artwork downloads are limited to 10 MiB.

Artwork supports GIFs. Animation pauses while the app is inactive and uses a still
frame with Reduce Motion. Longer animations are sampled to at most 120 frames
while preserving total playback duration. Frames are resized to keep decoded
artwork within 64 MiB instead of silently replacing the animation with a still image.

On iOS, `BTX.inAppCampaigns.preview(isBanner:title:body:imageURL:)` shows sample
content without sending a campaign or recording interactions. Pass `true` for a
banner or `false` for a card; an empty `imageURL` omits artwork. Keep preview controls
in developer-only screens. Use a real test campaign to verify delivery and actions.

See the [iOS integration guide](https://btx.so/docs/ios/in-app-campaigns) for setup
and testing, and the [campaign guide](https://btx.so/docs/campaigns/in-app) for
creating campaigns, managing audiences, and reviewing results.

Cards without an image show text and actions without a logo or image placeholder.
Only supplied card artwork is rendered; banners retain their project icon behavior.

## Campaign diagnostics

BTXClientKit 3.4.2 adds specific failure reasons and presentation stages to campaign diagnostics. With telemetry logs
enabled, a matching event links the failure to its campaign and delivery attempt.
Temporary screen interruptions defer the campaign until a later foreground
activation. No additional host configuration is required.

[All guides](README.md)
