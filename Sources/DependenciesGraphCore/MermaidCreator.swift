import Foundation

public enum MermaidCreator {
    public static func create(
        from modules: [Module],
        stripTransitive: Bool = false
    ) -> String {
        let processedModules = stripTransitive ? stripTransitiveDependencies(modules) : modules

        let mermaidLines = processedModules
            .flatMap { module in
                module.dependencies.map { dependency in
                    "    \(module.name)-->\(dependency);"
                }
            }

        return ["```mermaid", "graph TD;"]
            .appending(contentsOf: mermaidLines)
            .appending("```")
            .joined(separator: "\n")
    }

    private static func stripTransitiveDependencies(
        _ modules: [Module]
    ) -> [Module] {
        let dependencyMap = modules.reduce(into: [String: Set<String>]()) { map, module in
            map[module.name] = Set(module.dependencies)
        }

        let transitiveDependencies = modules.reduce(into: [String: Set<String>]()) { result, module in
            var visited = Set<String>()
            var transitive = Set<String>()
            findTransitiveDependencies(
                from: module.name,
                dependencyMap: dependencyMap,
                visited: &visited,
                transitive: &transitive
            )
            result[module.name] = transitive
        }

        return modules.map { module in
            let directDependencies = Set(module.dependencies)

            let filteredDependencies = directDependencies.filter { dependency in
                !directDependencies
                    .subtracting([dependency])
                    .contains { otherDependency in
                        let otherTransitive = transitiveDependencies[otherDependency] ?? Set()
                        return otherTransitive.contains(dependency)
                    }
            }

            return Module(name: module.name, dependencies: Array(filteredDependencies))
        }
    }

    private static func findTransitiveDependencies(
        from moduleName: String,
        dependencyMap: [String: Set<String>],
        visited: inout Set<String>,
        transitive: inout Set<String>
    ) {
        guard !visited.contains(moduleName) else { return }
        visited.insert(moduleName)

        dependencyMap[moduleName]?.forEach { dependency in
            transitive.insert(dependency)
            findTransitiveDependencies(
                from: dependency,
                dependencyMap: dependencyMap,
                visited: &visited,
                transitive: &transitive
            )
        }
    }
}

private extension Array {
    func appending(_ element: Element) -> Array {
        return self + [element]
    }

    func appending<S: Sequence>(contentsOf sequence: S) -> Array where S.Element == Element {
        return self + Array(sequence)
    }
}
