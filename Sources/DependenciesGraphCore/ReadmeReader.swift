import Foundation

public enum ReadmeReader {
    public static func removeLines(_ readme: String, from: String) -> String {
        var removedReadme = ""
        let lines = readme.components(separatedBy: "\n")
        for (index, line) in lines.enumerated() {
            if line.contains(from) {
                break
            }
            removedReadme += line
            if index < lines.count {
                removedReadme += "\n"
            }
        }
        return removedReadme
    }
}
