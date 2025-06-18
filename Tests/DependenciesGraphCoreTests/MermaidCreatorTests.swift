@testable import DependenciesGraphCore
import Testing

struct MermaidCreatorTests {
    @Test func createMermaid() {
        let modules = [
            Module(name: "A", dependencies: ["B"]),
            Module(name: "B", dependencies: ["C"]),
            Module(name: "C", dependencies: []),
        ]

        let result = MermaidCreator.create(from: modules)
        let expected = """
        ```mermaid
        graph TD;
            A-->B;
            B-->C;
        ```
        """

        #expect(result == expected)
    }

    @Test func createMermaidWithTransitiveStripping() {
        let modules = [
            Module(name: "A", dependencies: ["B", "C"]),
            Module(name: "B", dependencies: ["C"]),
            Module(name: "C", dependencies: []),
        ]

        let result = MermaidCreator.create(from: modules, stripTransitive: true)
        let expected = """
        ```mermaid
        graph TD;
            A-->B;
            B-->C;
        ```
        """

        #expect(result == expected)
    }

    @Test func createMermaidWithoutTransitiveStripping() {
        let modules = [
            Module(name: "A", dependencies: ["B", "C"]),
            Module(name: "B", dependencies: ["C"]),
            Module(name: "C", dependencies: []),
        ]

        let result = MermaidCreator.create(from: modules, stripTransitive: false)
        let expected = """
        ```mermaid
        graph TD;
            A-->B;
            A-->C;
            B-->C;
        ```
        """

        #expect(result == expected)
    }

    @Test func complexTransitiveDependencies() {
        let modules = [
            Module(name: "A", dependencies: ["B", "C", "D"]),
            Module(name: "B", dependencies: ["C"]),
            Module(name: "C", dependencies: ["D"]),
            Module(name: "D", dependencies: []),
        ]

        let result = MermaidCreator.create(from: modules, stripTransitive: true)
        let expected = """
        ```mermaid
        graph TD;
            A-->B;
            B-->C;
            C-->D;
        ```
        """

        #expect(result == expected)
    }

    @Test func noTransitiveDependencies() {
        let modules = [
            Module(name: "A", dependencies: ["B"]),
            Module(name: "C", dependencies: ["D"]),
            Module(name: "B", dependencies: []),
            Module(name: "D", dependencies: []),
        ]

        let result = MermaidCreator.create(from: modules, stripTransitive: true)
        let expected = """
        ```mermaid
        graph TD;
            A-->B;
            C-->D;
        ```
        """

        #expect(result == expected)
    }
}
