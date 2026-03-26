import Foundation

extension Bundle {
    func data(
        forResource name: String,
        withExtension ext: String,
        options: Data.ReadingOptions = []
    ) throws -> Data {
        guard let url = url(forResource: name, withExtension: ext) else {
            throw NSError(domain: bundleIdentifier ?? "", code: NSFileReadNoSuchFileError)
        }

        return try Data(contentsOf: url, options: options)
    }
}
