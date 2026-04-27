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
}
