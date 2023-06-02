# swift-dependencies-graph
CLI tool to output mermaid diagrams of module dependencies for multi-modularized projects in Swift Package Manager.

## Installation
#### Mint
```
Ryu0118/swift-dependencies-graph@0.0.2
```

#### Homebrew
```
$ brew install Ryu0118/dgraph/dgraph
``` 
##### update
```
$ brew update
$ brew upgrade Ryu0118/dgraph/dgraph
```

## Usage
```
USAGE: dgraph <project-path> [--add-to-readme]

ARGUMENTS:
  <project-path>          Project root directory

OPTIONS:
  --add-to-readme         Add Mermaid diagram to README
  -h, --help              Show help information.
```

## Example
```mermaid
graph TD;
    App-->HogeFeature;
    App-->FugaFeature;
    App-->LoginFeature;
    LoginFeature-->CoreModule;
    HogeFeature-->CoreModule;
    FugaFeature-->CoreModule;
```

## Package Dependencies
```mermaid
graph TD;
    DependenciesGraph-->DependenciesGraphCore;
    DependenciesGraphCoreTests-->DependenciesGraphCore;
```
