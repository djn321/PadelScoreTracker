# Xcode Setup Instructions

Follow these steps to create the Xcode project and add the source files.

## Prerequisites
- Xcode installed (version 15 or later recommended)
- Apple Developer account (free account works for testing on your own devices)

## Step 1: Create a New Project

1. Open Xcode
2. Click **File > New > Project** (or press Cmd+Shift+N)
3. Select the **watchOS** tab at the top
4. Choose **App** and click **Next**
5. Fill in the project details:
   - **Product Name:** PadelScoreTracker
   - **Team:** Select your Apple ID (or "None" if not signed in)
   - **Organization Identifier:** com.yourname (e.g., com.nick)
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Watch-only App:** Yes (check this box)
6. Click **Next**
7. Choose where to save the project (the PadelScoreTracker folder is fine)
8. Click **Create**

## Step 2: Replace the Default Files

Xcode will have created some default files. Replace them with the source code:

### Replace ContentView.swift
1. In the Project Navigator (left sidebar), find **ContentView.swift**
2. Click on it to open it
3. Select all the content (Cmd+A)
4. Open `SourceCode/ContentView.swift` from this folder
5. Copy all its contents
6. Paste into Xcode, replacing the default content

### Replace the App file
1. Find the file named **PadelScoreTrackerApp.swift** (or similar)
2. Replace its contents with the code from `SourceCode/PadelScoreTrackerApp.swift`

### Add MatchModel.swift
1. Right-click on the **PadelScoreTracker** folder in the Project Navigator
2. Select **New File...**
3. Choose **Swift File** and click **Next**
4. Name it **MatchModel** and click **Create**
5. Replace the contents with the code from `SourceCode/MatchModel.swift`

## Step 3: Run the App

### On Simulator
1. At the top of Xcode, click the device selector (next to the Play button)
2. Choose an Apple Watch simulator (e.g., "Apple Watch Series 9 (45mm)")
3. Click the **Play** button (or press Cmd+R)
4. The simulator will launch and show your app

### On Your Actual Watch
1. Connect your iPhone to your Mac with a cable
2. Make sure your Apple Watch is paired with that iPhone
3. In the device selector, choose your Apple Watch
4. Click **Play**
5. You may need to trust the developer certificate on your watch:
   - On iPhone: Settings > General > VPN & Device Management > Trust your developer certificate
   - On Watch: The app should appear automatically

## Troubleshooting

**"Signing for requires a development team"**
- Go to the project settings (click the blue project icon at the top of the navigator)
- Select the target "PadelScoreTracker Watch App"
- Under "Signing & Capabilities", select your Team

**App doesn't appear on watch**
- Make sure Watch is connected and unlocked
- Check iPhone: Watch app > My Watch > Installed on Apple Watch

**Simulator is slow**
- This is normal for watch simulators
- Testing on a real device is faster

## Next Steps

Once the basic app is working, future enhancements could include:
- Undo button
- Serve tracking
- Match history
- Haptic feedback on score changes
