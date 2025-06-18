@testable import DependenciesGraphCore
import Testing

struct StringNewLineTests {
    @Test func newLineWithoutIndent() {
        var str = "Line1"
        str.newLine("Line2")
        #expect(str == "Line1\nLine2")
    }

    @Test func newLineWithIndent1() {
        var str = "Line1"
        str.newLine("Line2", indent: 1)
        #expect(str == "Line1\n    Line2")
    }

    @Test func newLineWithIndent2() {
        var str = "Line1"
        str.newLine("Line2", indent: 2)
        #expect(str == "Line1\n        Line2")
    }
}
