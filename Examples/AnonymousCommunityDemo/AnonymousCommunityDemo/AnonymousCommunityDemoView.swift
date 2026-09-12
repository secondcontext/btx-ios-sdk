import BTXClientKit
import SwiftUI

enum AnonymousCommunityDemoIdentifiers {
    static let openCommunity = "anonymousCommunityDemo.openCommunity"
    static let status = "anonymousCommunityDemo.status"
}

private enum AnonymyTab: Hashable {
    case home
    case settings
}

struct AnonymousCommunityDemoView: View {
    let configurationState: AnonymousCommunityDemoConfigurationState

    @State private var selectedTab: AnonymyTab = .home
    @State private var presentationFailure: BTXCommunityPresentationFailure?

    var body: some View {
        ZStack {
            AnonymyWallpaper()

            switch configurationState {
            case .ready:
                appShell
            case let .missing(keys):
                missingConfigurationView(keys: keys)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var appShell: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                AnonymyHomeView(
                    presentationFailure: presentationFailure,
                    onPresentCommunity: presentCommunity
                )
                .background(AnonymyWallpaper())
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarBackground(.hidden, for: .tabBar)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(AnonymyTab.home)

            NavigationStack {
                AnonymySettingsView()
                    .background(AnonymyWallpaper())
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarBackground(.hidden, for: .tabBar)
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(AnonymyTab.settings)
        }
        .tint(.white)
    }

    private func missingConfigurationView(keys: [String]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Configuration needed", systemImage: "wrench.and.screwdriver")
                .font(.title2.bold())

            Text("Copy the local xcconfig example and add your iOS publishable client key.")
                .foregroundStyle(.secondary)

            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(.caption.monospaced())
            }
        }
        .padding(24)
        .frame(maxWidth: 420, alignment: .leading)
        .anonymyGlass(in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(24)
    }

    private func presentCommunity() {
        // Present Community from any customer-initiated button or settings row.
        // The SDK owns the sheet, navigation, loading, and mutations.
        switch BTX.community.present() {
        case .presented:
            presentationFailure = nil
        case let .failed(failure):
            presentationFailure = failure
        @unknown default:
            presentationFailure = .unavailable
        }
    }
}

private struct AnonymyHomeView: View {
    let presentationFailure: BTXCommunityPresentationFailure?
    let onPresentCommunity: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                header
                protectionCard
                privacyDetails
                communityCard
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 112)
        }
        .navigationTitle("Anonymy")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Private by design")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("A quiet place to check your privacy at a glance.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.68))
        }
    }

    private var protectionCard: some View {
        HStack(spacing: 18) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .anonymyGlass(
                    tint: Color.indigo.opacity(0.30),
                    in: Circle()
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Private mode active")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)

                Text("No account is connected")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.62))
            }

            Spacer(minLength: 0)
        }
        .padding(20)
        .anonymyGlass(in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var privacyDetails: some View {
        HStack(spacing: 12) {
            AnonymyMetric(
                title: "Identity",
                value: "Hidden",
                systemImage: "person.crop.circle.badge.xmark"
            )

            AnonymyMetric(
                title: "Telemetry",
                value: "Off",
                systemImage: "antenna.radiowaves.left.and.right.slash"
            )
        }
    }

    private var communityCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.10), in: Circle())

                VStack(alignment: .leading, spacing: 5) {
                    Text("Help improve Anonymy")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("Share ideas and join the conversation without creating an account.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button(action: onPresentCommunity) {
                Label("Give feedback", systemImage: "heart")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .anonymyPrimaryButton()
            .accessibilityIdentifier(AnonymousCommunityDemoIdentifiers.openCommunity)

            Text(presentationFailure == nil ? "Anonymous by default" : "Community is unavailable")
                .font(.caption.weight(.medium))
                .foregroundStyle(
                    presentationFailure == nil ? .white.opacity(0.52) : .red.opacity(0.9)
                )
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier(AnonymousCommunityDemoIdentifiers.status)
        }
        .padding(20)
        .anonymyGlass(in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

private struct AnonymyMetric: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.84))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.52))

                Text(value)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .anonymyGlass(in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct AnonymySettingsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                AnonymySettingsRow(
                    title: "Private mode",
                    detail: "Active",
                    systemImage: "lock.shield.fill"
                )
                AnonymySettingsRow(
                    title: "App telemetry",
                    detail: "Off",
                    systemImage: "antenna.radiowaves.left.and.right.slash"
                )
                AnonymySettingsRow(
                    title: "Community identity",
                    detail: "Anonymous",
                    systemImage: "person.crop.circle.badge.questionmark"
                )

                Text("Your Community profile uses a random identifier scoped to this Community. No name or email is sent.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.54))
                    .padding(.top, 10)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 112)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AnonymySettingsRow: View {
    let title: String
    let detail: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white.opacity(0.84))
                .frame(width: 28)

            Text(title)
                .font(.body.weight(.medium))
                .foregroundStyle(.white)

            Spacer()

            Text(detail)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.56))
        }
        .padding(.horizontal, 18)
        .frame(height: 58)
        .anonymyGlass(in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct AnonymyWallpaper: View {
    var body: some View {
        GeometryReader { geometry in
            Image("AppWallpaper")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .overlay(Color.black.opacity(0.10))
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private extension View {
    @ViewBuilder
    func anonymyGlass<T: InsettableShape>(
        tint: Color? = nil,
        interactive: Bool = false,
        in shape: T
    ) -> some View {
        if #available(iOS 26.0, *) {
            if interactive {
                glassEffect(.regular.tint(tint ?? .clear).interactive(), in: shape)
            } else {
                glassEffect(.regular.tint(tint ?? .clear), in: shape)
            }
        } else {
            background(.ultraThinMaterial, in: shape)
                .overlay(shape.stroke(Color.white.opacity(0.12), lineWidth: 0.75))
        }
    }

    @ViewBuilder
    func anonymyPrimaryButton() -> some View {
        if #available(iOS 26.0, *) {
            buttonStyle(.glassProminent)
                .tint(Color(red: 0.34, green: 0.38, blue: 0.90))
                .foregroundStyle(.white)
        } else {
            buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.white)
                .foregroundStyle(.black)
        }
    }
}
