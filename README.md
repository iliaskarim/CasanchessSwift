# Casanchess

Swift package wrapper for the Casanchess engine.

The engine source and build pipeline live on the [`apple-library-build`](https://github.com/iliaskarim/casanchess/tree/apple-library-build) branch of [`iliaskarim/casanchess`](https://github.com/iliaskarim/casanchess).

This repository is self-contained for SwiftPM consumers:

- `Sources/Casanchess` exposes the Swift API and bundles the NNUE resource.
- `Sources/CasanchessBridge` contains the Objective-C++ bridge and required engine headers.
- `Artifacts/casanchess.xcframework` contains the prebuilt engine library.

## Build

```sh
swift build
```

## License

MIT License. See [LICENSE](LICENSE) for details.
