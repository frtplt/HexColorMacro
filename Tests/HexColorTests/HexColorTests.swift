import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(HexColorMacros)
import HexColorMacros

let testMacros: [String: Macro.Type] = [
    "uiColor": HexMacro.self,
]
#endif

final class HexColorTests: XCTestCase {
    func testValidHex() {
        assertMacroExpansion(
            #"""
            #uiColor("#111154")
            """#,
            expandedSource: #"""
            UIKit.UIColor(red: 0.06666666666666667, green: 0.06666666666666667, blue: 0.32941176470588235, alpha: 1.0)
            """#,
            macros: testMacros
        )
    }
}
