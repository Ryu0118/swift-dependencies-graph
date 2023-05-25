import XCTest
@testable import DependenciesGraphCore

final class ReadmeReaderTests: XCTestCase {
    func testRemoveLinesWithTargetString() {
        XCTAssertEqual(
            ReadmeReader.removeLines(
                "This is a readme text.",
                from: "readme"
            ),
            ""
        )
    }

    func testRemoveLinesWithoutTargetString() {
        XCTAssertEqual(
            ReadmeReader.removeLines(
                "This is a readme text.",
                from: "Non-existent string"
            ),
            "This is a readme text.\n"
        )
    }

    func testRemoveLinesWithEmptyString() {
        XCTAssertEqual(
            ReadmeReader.removeLines(
                "",
                from: "Non-existent string"
            ),
            "\n"
        )
    }
}
