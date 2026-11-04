# Help Center

Let customers find answers without leaving your app. Help Center presents your
published articles in a native, searchable iOS interface. Place pairing,
charging, and firmware-update guides next to the screens where customers need them.

Complete the [quickstart](quickstart.md), then add Help Center to your existing
startup configuration. Configuration and presentation run on the main actor.

## Enable Help Center

Add `.helpCenter` to the feature set. This example keeps Customer Messenger enabled:

```swift
BTX.configure(
    BTXConfiguration(
        publishableClientKey: "cfk_...",
        features: [.messenger, .helpCenter]
    )
)
```

BTX resolves the project automatically from your publishable key.
Help Center also works without a signed-in account. If your app identifies a
customer, it shares that identity with the other enabled BTX features.

## Open from your app

Connect a Help Center button to the SDK-owned sheet:

```swift
BTX.helpCenter.present()
```

For a SwiftUI button, use the SDK's icon:

```swift
Button("Help Center", systemImage: BTXHelpCenter.systemImageName) {
    BTX.helpCenter.present()
}
```

Customers can browse articles by category and section, search, and open formatted
articles with images and media. Only published public articles are visible;
drafts, archived articles, and internal content stay hidden.

## Open a specific article

For example, open a pairing guide from a connection error screen. Replace
`pairingArticleID` with that published article’s ID in BTX:

```swift
BTX.helpCenter.presentArticle(id: pairingArticleID)
```

If the article is no longer published, the SDK shows an unavailable message.

## Embed Help Center

Inside your own SwiftUI view, you can embed the SDK view after configuration:

```swift
if let helpCenterView = BTX.helpCenter.view() {
    helpCenterView
}
```

## Customize presentation

Pass `BTXHelpCenterOptions` through `BTXConfiguration.helpCenterOptions` at startup:

```swift
BTXHelpCenterOptions(
    title: "Help Center",
    sheetHeight: .half
)
```

The sheet starts full-screen by default. Choose `.quarter` or `.half` for a
shorter starting height. It inherits `messengerOptions.theme` unless you supply
a separate Help Center theme. See [theming](theming.md).

## Verify the integration

1. Publish a public article in your BTX project.
2. Open Help Center in your app and find the article through browsing or search.
3. Open the same article by ID from a contextual help button.

[Customer Messenger](customer-messenger.md) · [All guides](README.md)
