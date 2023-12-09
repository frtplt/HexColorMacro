# HexMacroColor

The macro in the example checks whether the hex code you entered is valid at compile time. If it is not valid, it shows a warning. If it is valid, it returns a color code of the type on the platform you want to use.

## Installation

In Xcode, go to File > Add Package Dependency and paste the repository URL:
```
https://github.com/frtplt/HexColorMacro.git
```

## Usage

In your Swift file, import the HexColors package:
```swift
import HexColor
```

```swift
 let uiColor = #uiColor("#ffffff") -> UIKit.UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
 let color   = #color("#ffffff")   -> SwiftUI.Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
 let nsColor = #nsColor("#ffffff") -> AppKit.NSColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
 let cgColor = #cgColor("#ffffff") -> CoreGraphics.CGColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
```
