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
