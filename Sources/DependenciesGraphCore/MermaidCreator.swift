import Foundation

public enum MermaidCreator {
    public static func create(from modules: [Module], stripTransitive: Bool = false) -> String {
        let processedModules = stripTransitive ? stripTransitiveDependencies(modules) : modules

        var mermaid = "```mermaid"
        mermaid.newLine("graph TD;")
        for module in processedModules {
            for dependency in module.dependencies {
                mermaid.newLine("\(module.name)-->\(dependency);", indent: 1)
            }
        }
        mermaid.newLine("```")
        return mermaid
    }

    private static func stripTransitiveDependencies(_ modules: [Module]) -> [Module] {
        // 全ての依存関係のマップを作成
        var dependencyMap: [String: Set<String>] = [:]
        for module in modules {
            dependencyMap[module.name] = Set(module.dependencies)
        }

        // 推移的依存関係を計算（Floyd-Warshall的アプローチ）
        var transitiveDependencies: [String: Set<String>] = dependencyMap

        // 各モジュールについて推移的依存関係を計算
        for module in modules {
            var visited = Set<String>()
            var transitive = Set<String>()
            findTransitiveDependencies(from: module.name,
                                       dependencyMap: dependencyMap,
                                       visited: &visited,
                                       transitive: &transitive)
            transitiveDependencies[module.name] = transitive
        }

        // 直接的依存関係から推移的依存関係を除去
        return modules.map { module in
            let directDependencies = Set(module.dependencies)
            var filteredDependencies = directDependencies

            // 各直接依存関係について、それが他の直接依存関係を通じて到達可能かチェック
            for dependency in directDependencies {
                for otherDependency in directDependencies {
                    if dependency != otherDependency {
                        let otherTransitive = transitiveDependencies[otherDependency] ?? Set()
                        if otherTransitive.contains(dependency) {
                            filteredDependencies.remove(dependency)
                        }
                    }
                }
            }

            return Module(name: module.name, dependencies: Array(filteredDependencies))
        }
    }

    private static func findTransitiveDependencies(from moduleName: String,
                                                   dependencyMap: [String: Set<String>],
                                                   visited: inout Set<String>,
                                                   transitive: inout Set<String>)
    {
        if visited.contains(moduleName) {
            return
        }
        visited.insert(moduleName)

        guard let dependencies = dependencyMap[moduleName] else { return }

        for dependency in dependencies {
            transitive.insert(dependency)
            findTransitiveDependencies(from: dependency,
                                       dependencyMap: dependencyMap,
                                       visited: &visited,
                                       transitive: &transitive)
        }
    }
}
