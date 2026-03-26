import DependenciesGraphCore

struct DumpPackageMock: DumpPackage {
    
    // MARK: - dumpPackage

    private let dumpPackageReturnValue: String

    init(dumpPackageReturnValue: String) {
        self.dumpPackageReturnValue = dumpPackageReturnValue
    }

    func dumpPackage(packageRootDirectoryPath: String?) throws -> String {
        dumpPackageReturnValue
    }
}
