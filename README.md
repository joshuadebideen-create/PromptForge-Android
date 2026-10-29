# PromptForge Android

Native Android WebView wrapper for PromptForge Mobile Game Studio. The app bundles the HTML/CSS/JS locally, so its interface opens offline. Internet is needed for GitHub repository upload.

## Build an APK for free on GitHub Actions
1. Create a **new separate repository** named `PromptForge-Android` (do not overwrite `unity-mobile-studio-android` or the International Truck Simulator repository).
2. Upload all contents of this folder to the repository root, including `.github/workflows/build-apk.yml`.
3. Open the repository's **Actions** tab and run **Build PromptForge Android APK** (or push a commit to `main`).
4. Open the completed run, scroll to **Artifacts**, and download `PromptForge-Android-debug-APK`.
5. Extract the ZIP on your phone and install `app-debug.apk`. If Android asks, allow installation from that file manager/browser.
6. Debug APKs are for personal testing, not a Play Store release.

## Current scope
The APK contains a prompt-to-blueprint generator, starter templates for Godot and Unity, ZIP/JSON export to Downloads/PromptForge, and an optional GitHub repository uploader. The prompt generator currently uses local rules and templates. It is not yet an AI model and does not generate a complete commercial-scale game automatically.

## GitHub token
For repository creation, create a fine-grained personal access token only when needed, with permission to create repositories and write repository contents. Paste it in the app only on your own device. The token is held in page memory and cleared after an upload attempt; never commit it or share it. Consider revoking it after use.

## Android security
The JavaScript interface is exposed only to bundled app-owned HTML/JS, and the WebView routes non-app links to the external browser. Do not change the app to load arbitrary websites while leaving the JavaScript interface enabled.
