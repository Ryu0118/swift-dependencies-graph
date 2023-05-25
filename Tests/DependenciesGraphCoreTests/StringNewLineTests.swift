import XCTest
@testable import DependenciesGraphCore

final class StringNewLineTests: XCTestCase {
    func testNewLineWithoutIndent() {
        var str = "Line1"
        str.newLine("Line2")
        XCTAssertEqual(str, "Line1\nLine2")
    }

    func testNewLineWithIndent1() {
        var str = "Line1"
        str.newLine("Line2", indent: 1)
        XCTAssertEqual(str, "Line1\n    Line2")
    }

    func testNewLineWithIndent2() {
        var str = "Line1"
        str.newLine("Line2", indent: 2)
        XCTAssertEqual(str, "Line1\n        Line2")
    }
}
