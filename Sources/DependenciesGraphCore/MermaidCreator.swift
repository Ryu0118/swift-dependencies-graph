import Foundation

public enum MermaidCreator {
    public static func create(from modules: [Module]) -> String {
        var mermaid = "```mermaid"
        mermaid.newLine("graph TD;")
        for module in modules {
            for dependency in module.dependencies {
                mermaid.newLine("\(module.name)-->\(dependency);", indent: 1)
            }
        }
        mermaid.newLine("```")
        return mermaid
    }
}

extension String {
    mutating func newLine(_ new: String, indent: Int = 0) {
        self = self + "\n" + String(repeating: "    ", count: indent) + new
    }
}
