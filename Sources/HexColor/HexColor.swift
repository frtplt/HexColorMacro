// The Swift Programming Language
// https://docs.swift.org/swift-book

#if canImport(UIKit)
import UIKit

@freestanding(expression)
public macro uiColor(_ stringLiteral: String) -> UIColor = #externalMacro(module: "HexColorMacros", type: "HexMacroUIColor")

#endif

#if canImport(SwiftUI)
import SwiftUI

@freestanding(expression)
public macro color(_ stringLiteral: String) -> Color = #externalMacro(module: "HexColorMacros", type: "HexMacroColor")

#endif

#if canImport(CoreGraphics)
import CoreGraphics

@freestanding(expression)
public macro cgColor(_ stringLiteral: String) -> CGColor = #externalMacro(module: "HexColorMacros", type: "HexMacroCGColor")

#endif

#if canImport(AppKit)
import AppKit

@freestanding(expression)
public macro nsColor(_ stringLiteral: String) -> NSColor = #externalMacro(module: "HexColorMacros", type: "HexMacroNSColor")

#endif

