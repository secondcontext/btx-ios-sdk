# Theming

Match Customer Messenger and feedback to your app. Add your theme to the existing
startup configuration through `BTXMessengerOptions.theme`.

Messenger, feedback, Community, and Help Center sheets use untinted clear Liquid Glass over
a neutral system blur on iOS 26. Their color comes from the host content behind them;
`backgroundColor` no longer adds an opaque color wash to these floating sheets.
Older iOS versions use the system blur alone. Native materials respond to the
host appearance and system accessibility settings. Text, controls, chat bubbles,
and branding still use `BTXTheme`. Foreground notifications also default to
untinted clear glass with neutral blur; hosts can explicitly choose `.regular`
or set `foregroundNotificationMaterialOpacity` to apply their notification tint.

No theme is required. To choose a complete SDK appearance, use a preset:

```swift
let messengerOptions = BTXMessengerOptions(
    theme: .dark
)
```

For host branding, map the six semantic colors the SDK needs. The palette keeps
the Messenger, Community, and Help Center sheets, feedback form, bubbles, composers,
controls, links, and foreground notifications aligned automatically:

```swift
let messengerOptions = BTXMessengerOptions(
    theme: BTXTheme(
        palette: BTXThemePalette(
            background: BTXColor(red: 0.04, green: 0.05, blue: 0.06),
            surface: BTXColor(red: 0.10, green: 0.11, blue: 0.12),
            primaryText: BTXColor(red: 0.96, green: 0.97, blue: 0.98),
            secondaryText: BTXColor(red: 0.68, green: 0.70, blue: 0.72),
            accent: BTXColor(red: 0.36, green: 0.76, blue: 0.92),
            accentForeground: BTXColor(red: 0.02, green: 0.03, blue: 0.04)
        ),
        colorScheme: .dark
    )
)
```

Use the detailed `BTXTheme` initializer only for deliberate per-surface
exceptions such as custom artwork, fonts, or a special notification treatment.
Message bubble fills are flattened against the configured messenger background,
so both incoming and outgoing bubbles remain opaque over busy host content.

## Theme options

- `BTXTheme.light` and `.dark` provide complete appearances. Omit the theme
  to keep the standard SDK appearance.
- `BTXThemePalette` maps six host-brand colors across every Messenger,
  feedback, and Community surface.
- `BTXTheme.backgroundColor` controls embedded messenger backgrounds and derived theme colors. Floating Messenger, feedback, and Community sheets use neutral blur and untinted clear glass.
- `BTXTheme.surfaceColor` controls themed cards and neutral surfaces.
- `BTXTheme.historyRowBackgroundColor` and `historyRowStrokeColor`
  independently theme conversation-history rows. If a requested row fill
  cannot maintain 4.5:1 contrast with both configured history text colors,
  the SDK falls back to the themed surface color.
- `BTXTheme.emptyStateLogo` supplies shared artwork above the messenger home heading and in the new-message view. Homes without a logo omit the artwork; the new-message view uses a message symbol as its fallback.
- `BTXTheme.emptyStateLogoMaxWidth` and `emptyStateLogoMaxHeight` constrain that logo.
- `BTXTheme.emptyStateLogoToCTASpacing` controls the gap between the home logo and primary action.
- `BTXTheme.primaryCTAColor` controls primary action fill.
- `BTXTheme.primaryCTATextColor` controls primary action text and icon color.
- `BTXTheme.primaryCTAStyle` supports `.glass` and `.solid`.
- `BTXTheme.colorScheme` supports `.system`, `.light`, and `.dark` for hosts
  whose fixed palette must not follow the device appearance.
- Message bubble, composer, and foreground-notification colors can be themed for light host apps. When a themed host omits the incoming bubble color, the SDK derives a subtle fill from the primary text color so operator messages remain distinct from the page background.
- Incoming and outgoing bubble fills are rendered opaquely. Translucent host bubble colors are first composited over `backgroundColor`, preserving their intended appearance without allowing live host content to show through.
- The standard appearance uses light customer bubbles with dark text and dark operator bubbles with light text. Explicit host bubble colors remain supported. Outgoing links use the bubble text color with an underline to remain readable against the fill.
- The composer input uses only its Liquid Glass surface; it never adds a static outline around the interactive glass shape.
- Foreground notifications show the replying operator's avatar when available,
  with the banner-specific logo as a compact project badge. The same logo is
  the fallback when no operator avatar is available.

[All guides](README.md)
