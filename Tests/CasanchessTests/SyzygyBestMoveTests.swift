import Casanchess
import Testing

@Suite(.serialized)
struct SyzygyBestMoveTests {
    @MainActor
    @Test func saavedraPositionUsesTablebaseWin() async {
        let engine = CasanchessEngine.shared

        // Saavedra position. With bundled Syzygy WDL loaded, depth-5 search
        // should keep the only winning tablebase result by advancing the pawn.
        engine.setPosition(fen: "8/8/1KP5/3r4/8/8/8/k7 w - - 0 1")

        var bestMoves: [String?] = []
        for await bestMove in engine.bestMove(depth: 5).values {
            bestMoves.append(bestMove)
        }

        #expect(bestMoves.count == 1)
        let firstBestMove = bestMoves.first ?? nil
        #expect(firstBestMove == "c6c7")
    }

    @MainActor
    @Test func troitzkyPositionKeepsWinningMoveAfterQuietMove() async {
        let engine = CasanchessEngine.shared

        // Troitzky position. With bundled Syzygy WDL loaded, depth-5 search
        // should keep the only winning tablebase result, Kb2. That move is
        // quiet, so the halfmove clock is 1 on every following node.
        // https://github.com/iliaskarim/CasanchessSwift/issues/1
        engine.setPosition(fen: "8/8/8/2p5/k7/8/2N5/KN6 w - - 0 1")

        var bestMoves: [String?] = []
        for await bestMove in engine.bestMove(depth: 5).values {
            bestMoves.append(bestMove)
        }

        #expect(bestMoves.count == 1)
        let firstBestMove = bestMoves.first ?? nil
        #expect(firstBestMove == "a1b2")
    }
}
