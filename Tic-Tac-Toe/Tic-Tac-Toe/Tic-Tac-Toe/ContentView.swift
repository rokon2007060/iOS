import SwiftUI

struct ContentView: View {
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var currentPlayer = "X"
    @State private var winner: String? = nil
    @State private var moves = 0
    
    var body: some View {
        VStack {
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            
            if let winner = winner {
                Text("\(winner) Wins! 🎉")
                    .font(.title)
                    .foregroundColor(.green)
            } else if moves == 9 {
                Text("It's a Draw! 🤝")
                    .font(.title)
                    .foregroundColor(.orange)
            } else {
                Text("Current Turn: \(currentPlayer)")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            // Game board
            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<3, id: \.self) { column in
                            Button(action: {
                                playerMove(row: row, column: column)
                            }) {
                                Text(board[row][column])
                                    .font(.system(size: 50, weight: .bold))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                            }
                            .disabled(board[row][column] != "" || winner != nil)
                        }
                    }
                }
            }
            .padding()
            
            Button("Reset Game") {
                resetGame()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    func playerMove(row: Int, column: Int) {
        guard board[row][column] == "" else { return }
        board[row][column] = currentPlayer
        moves += 1
        
        if checkWinner(for: currentPlayer) {
            winner = currentPlayer
        } else if moves < 9 {
            currentPlayer = "O"
            computerMove()
        }
    }
    
    func computerMove() {
        guard winner == nil else { return }
        
        var emptyCells: [(Int, Int)] = []
        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column] == "" {
                    emptyCells.append((row, column))
                }
            }
        }
        
        if let randomCell = emptyCells.randomElement() {
            let (row, column) = randomCell
            board[row][column] = "O"
            moves += 1
            
            if checkWinner(for: "O") {
                winner = "O"
            } else {
                currentPlayer = "X"
            }
        }
    }
    
    func checkWinner(for player: String) -> Bool {
        for i in 0..<3 {
            if board[i].allSatisfy({ $0 == player }) { return true } // Row
            if board.map({ $0[i] }).allSatisfy({ $0 == player }) { return true } // Column
        }
        if (board[0][0] == player && board[1][1] == player && board[2][2] == player) ||
           (board[0][2] == player && board[1][1] == player && board[2][0] == player) {
            return true
        }
        return false
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        winner = nil
        moves = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
