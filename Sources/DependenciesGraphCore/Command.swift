import Foundation

enum Command {
    static func run(
        launchPath: String,
        currentDirectoryPath: String? = nil,
        arguments: [String]
    ) throws -> String {
        let process = Process()
        process.launchPath = launchPath
        if let currentDirectoryPath {
            process.currentDirectoryPath = currentDirectoryPath
        }
        process.arguments = arguments
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()

        guard let data = try pipe.fileHandleForReading.readToEnd() else {
            throw CommandError.cannotReadData
        }

        return String(data: data, encoding: .utf8) ?? ""
    }
}

enum CommandError: Error {
    case cannotReadData
}
