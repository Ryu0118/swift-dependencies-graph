@testable import DependenciesGraphCore
import Testing
import Foundation

struct MermaidFromDumpTests {
    enum MermaidFromDumpTestsError: Error {
        case invalidUTF8Dump
    }
    
    struct TestCase {
        let isIncludeProduct: Bool
        let expected: String
        
        static let withoutProducts = TestCase(
            isIncludeProduct: false,
            expected: """
                ```mermaid
                graph TD;
                    ExampleApp-->ReduxKit;
                    ReduxKitExtensions-->ReduxKit;
                    ReduxKitExtensionsTests-->ReduxKitExtensions;
                    ReduxKitTests-->ReduxKit;
                    ReduxKitUI-->ReduxKit;
                ```
                """
        )
        
        static let withProducts = TestCase(
            isIncludeProduct: true,
            expected: """
                ```mermaid
                graph TD;
                    ExampleApp-->ReduxKit;
                    ReduxKitExtensions-->ReduxKit;
                    ReduxKitExtensions-->Collections;
                    ReduxKitExtensionsTests-->ReduxKitExtensions;
                    ReduxKitTests-->ReduxKit;
                    ReduxKitUI-->ReduxKit;
                ```
                """
        )
    }
        
    static let resources = ["dump_package", "dump_package_by_name", "dump_package_mix"]
    static let testCases = [TestCase.withProducts, .withoutProducts]
    
    @Test(arguments: resources, testCases)
    func createMermaid(resource: String, testCase: TestCase) throws {
        let dump = try Bundle.module.data(forResource: resource, withExtension: "json")
        guard let dumpString = String(data: dump, encoding: .utf8) else {
            Issue.record("Invalid UTF8 dump")
            throw MermaidFromDumpTestsError.invalidUTF8Dump
        }
        let dumpPackage = DumpPackageMock(dumpPackageReturnValue: dumpString)
        
        let sut = DependenciesReader(
            packageRootDirectoryPath: "",
            decoder: JSONDecoder(),
            dumpPackage: dumpPackage
        )
        let modules = try sut.readDependencies(isIncludeProduct: testCase.isIncludeProduct)
        let result = MermaidCreator.create(from: modules, stripTransitive: false)
        
        #expect(result == testCase.expected)
    }
}
