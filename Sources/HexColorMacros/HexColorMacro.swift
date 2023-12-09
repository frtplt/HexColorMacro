import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

enum HexMacroError: Error, CustomStringConvertible {
    case notValidHex
    case notStartWithTrueSign

    var description: String {
        switch self {
            case .notValidHex:
                return "Not valid input. Input must start with a # sign followed by 6 valid characters."
            case .notStartWithTrueSign:
                return "Input should start with # sign."
        }
    }
}

public protocol HexMacro: ExpressionMacro {
    static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax
}

extension HexMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            /// 1. Grab the first (and only) Macro argument.
            let argument = node.argumentList.first?.expression,

            /// 2. Ensure the argument contains of a single String literal segment.
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,

            /// 3. Grab the actual String literal segment.
            case .stringSegment(let literalSegment)? = segments.first
        else {
            throw HexMacroError.notValidHex
        }
        guard literalSegment.content.text.hasPrefix("#") else {
            throw HexMacroError.notStartWithTrueSign
        }

        let hexRegex = try! NSRegularExpression(pattern: "^#?[0-9A-Fa-f]{6}$")
        let range = NSRange(location: 0, length: literalSegment.content.text.utf16.count)
        if hexRegex.firstMatch(in: literalSegment.content.text, options: [], range: range) != nil {
            var hexSanitized = literalSegment.content.text.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            Scanner(string: hexSanitized).scanHexInt64(&rgb)

            let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgb & 0x0000FF) / 255.0

            return colorExpressionSyntax(red: red, green: green, blue: blue, alpha: 1)
        }
        else {
            throw HexMacroError.notValidHex
        }
    }
}

public struct HexMacroUIColor: HexMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "UIKit.UIColor(red: \(raw: red), green: \(raw: green), blue: \(raw: blue), alpha: \(raw: alpha))"
    }
}

public struct HexMacroColor: HexMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "SwiftUI.Color(red: \(raw: red), green: \(raw: green), blue: \(raw: blue), opacity: \(raw: alpha))"
    }
}

public struct HexMacroCGColor: HexMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "CoreGraphics.CGColor(red: CGFloat(\(raw: red)), green: CGFloat(\(raw: green)), blue: CGFloat(\(raw: blue)), alpha: CGFloat(\(raw: alpha)))"
    }
}

public struct HexMacroNSColor: HexMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "AppKit.NSColor(red: CGFloat(\(raw: red)), green: CGFloat(\(raw: green)), blue: CGFloat(\(raw: blue)), alpha: CGFloat(\(raw: alpha)))"
    }
}

@main
struct PushMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        HexMacroUIColor.self,
        HexMacroColor.self,
        HexMacroCGColor.self,
        HexMacroNSColor.self
    ]
}
