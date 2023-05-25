import XCTest
@testable import DependenciesGraphCore

class MermaidCreatorTests: XCTestCase {
    func testMermaidCreator() {
        XCTAssertEqual(
            MermaidCreator.create(
                from: [
                    Module(name: "module1", dependencies: ["module2", "module3"]),
                    Module(name: "module2", dependencies: ["module3"]),
                    Module(name: "module3", dependencies: [])
                ]
            ),
            """
            ```mermaid
            graph TD;
                module1-->module2;
                module1-->module3;
                module2-->module3;
            ```
            """
        )
    }

    func testMermaidCreatorWithNoDependencies() {
        XCTAssertEqual(
            MermaidCreator.create(
                from: [
                    Module(name: "module1", dependencies: []),
                    Module(name: "module2", dependencies: []),
                    Module(name: "module3", dependencies: [])
                ]
            ),
            """
            ```mermaid
            graph TD;
            ```
            """
        )
    }

    func testMermaidCreatorWithNoModules() {
        XCTAssertEqual(
            MermaidCreator.create(from: []),
            """
            ```mermaid
            graph TD;
            ```
            """
        )
    }
}
