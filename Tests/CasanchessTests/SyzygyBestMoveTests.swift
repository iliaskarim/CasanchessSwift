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
    @Test func twoKnightsVersusPawnKeepsWinningMoveAfterQuietMove() async {
        let engine = CasanchessEngine.shared

        // Two knights versus a pawn. Syzygy says this is a win, and the only
        // move that keeps it is Ka6. That step is quiet, so the halfmove clock
        // is 1 on every following node and Probe_WDL never consults the tables.
        // Depth 5 then plays Kc8, which the tables call a draw. The famous
        // Troitzky diagram already returns Kb2 at this depth, so it does not
        // show the bug.
        // https://github.com/iliaskarim/CasanchessSwift/issues/1
        engine.setPosition(fen: "N7/pK6/8/8/5N2/8/3k4/8 w - - 0 1")

        var bestMoves: [String?] = []
        for await bestMove in engine.bestMove(depth: 5).values {
            bestMoves.append(bestMove)
        }

        #expect(bestMoves.count == 1)
        let firstBestMove = bestMoves.first ?? nil
        #expect(firstBestMove == "b7a6")
    }
}
