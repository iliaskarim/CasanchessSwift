# Casanchess

Swift package wrapper for the Casanchess engine.

The engine source and build pipeline live on the [`apple-library-build`](https://github.com/iliaskarim/casanchess/tree/apple-library-build) branch of [`iliaskarim/casanchess`](https://github.com/iliaskarim/casanchess).

This repository is self-contained for SwiftPM consumers:

- `Sources/Casanchess` exposes the Swift API and bundles the NNUE resource.
- `Sources/CasanchessBridge` contains the Objective-C++ bridge and required engine headers.
- `Artifacts/casanchess.xcframework` contains the prebuilt engine library.

## Getting started

### Installation

Add the package to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/iliaskarim/CasanchessSwift.git", from: "1.0.0")
]
```

Then import the module:

```swift
import Casanchess
```

If you are using Xcode, you can also add this repository as a Swift Package dependency from **File > Add Package Dependencies...**, then add the `Casanchess` product to your app target.

### Basic usage

Use the shared engine from the main actor:

```swift
let engine = CasanchessEngine.shared
engine.resetGame()
_ = engine.applyMove("e2e4")

for await score in engine.evaluate(depth: 6).values {
    print("score", score)
}

for await bestMove in engine.bestMove(depth: 6).values {
    print("best move", bestMove ?? "none")
}
```

Set a position directly with FEN when you do not want to replay moves:

```swift
engine.setPosition(fen: "8/8/1KP5/3r4/8/8/8/k7 w - - 0 1")
```

## Syzygy tablebases

The engine can use optional Syzygy WDL files for endgame probing.

When using `CasanchessSwift` from a remote package URL, add the `.rtbw` files to your app target's resources, usually in a folder named `syzygy`, then pass that folder path to the engine:

```swift
if let path = Bundle.main.path(forResource: "syzygy", ofType: nil) {
    CasanchessEngine.shared.loadSyzygy(path: path, probeLimit: 5)
}
```

When developing this package locally, you can place `.rtbw` files under:

```sh
Sources/Casanchess/syzygy/
```

Those local files are intentionally ignored by git because tablebases are large. The current wrapper uses WDL probing during search; DTZ `.rtbz` files are not used.

## Build

```sh
swift build
```

## License

MIT License. See [LICENSE](LICENSE) for details.
