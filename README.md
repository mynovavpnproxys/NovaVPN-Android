# NOVA VPN

NOVA VPN is a Flutter Android VPN client prototype using the sing-box engine.

## Current scope

- Persian-language dashboard and server management UI.
- Import and local storage of supported proxy share links.
- sing-box configuration generation for supported VLESS, VMess, Trojan, Shadowsocks, Hysteria2 and TUIC profiles.
- Explicit disclosure before starting a VPN connection.
- Optional, user-initiated advertising/support link.
- GitHub Actions workflow intended to analyze, test, build a release APK, and upload it as an artifact.

## Important limitations

- A valid profile is required. This repository does not include a guaranteed free VPN endpoint, and no public proxy should be treated as secure or reliable without verification.
- A green CI build is not a substitute for testing VPN connectivity, DNS behavior, IPv4/IPv6 routing, reconnection, and traffic-leak behavior on real Android devices.
- Before a Google Play release, verify all protocol configurations, add a complete privacy policy and support contact, complete the VpnService declaration, and provide the required review evidence.
- The current Adsterra Smartlink is opened only after the user explicitly taps the optional support item. It must not be used to redirect VPN traffic or interrupt connection flows.

## Build

The GitHub Actions workflow in `.github/workflows/android.yml` generates the Android platform project, runs `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter build apk --release`, then uploads `app-release.apk` as the `NovaVPN-APK` artifact when Actions are enabled and the workflow succeeds.

## Licensing

Review the sing-box core and Flutter plugin licenses and comply with their redistribution/source-disclosure requirements before publishing.
