@testable import DependenciesGraphCore
import Testing

struct ReadmeReaderTests {
    @Test func removeLinesWithTargetString() {
        #expect(
            ReadmeReader.removeLines(
                "This is a readme text.",
                from: "readme"
            ) == ""
        )
    }

    @Test func removeLinesWithoutTargetString() {
        #expect(
            ReadmeReader.removeLines(
                "This is a readme text.",
                from: "Non-existent string"
            ) == "This is a readme text.\n"
        )
    }

    @Test func removeLinesWithEmptyString() {
        #expect(
            ReadmeReader.removeLines(
                "",
                from: "Non-existent string"
            ) == "\n"
        )
    }
}
