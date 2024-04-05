
import Foundation

let symbols = (
    empty: " ",
    player1: "X",
    player2: "O"
)

var field = [[String]]()

print("Добро пожаловать в игру: ")

while true {
    let player1Name = getDataFromUser(description: "Введите имя первого игрока")
    guard !player1Name.isEmpty else {
        print("Вы ввели неверное имя первого игрока")
        continue
    }
    let player2Name = getDataFromUser(description: "Введите имя второго игрока")
    guard !player2Name.isEmpty else {
        print("Вы ввели неверное имя второго игрока")
        continue
    }
    let fieldSize = getDataFromUser(description: "Введите размер игрового поля")
    guard let fieldSize = Int(fieldSize), fieldSize > 0 else {
        print("Вы ввели неверный размер игрового поля")
        continue
    }
    
    
    field = [[String]]()
    for _ in 0..<fieldSize {
        var row = [String] ()
        for _ in 0..<fieldSize {
            row.append(symbols.empty)
        }
        field.append(row)
    }
    
    var winnerSymbol: String?
    while true {
        playerTurn(playerName: player1Name, symbol: symbols.player1, fieldSize: fieldSize)
        printField(fieldSize: fieldSize)
        if let symbol = checkPlayerWon() {
            winnerSymbol = symbol
            break
        }
        if checkIfGameOver() {
            break
        }
        
        playerTurn(playerName: player2Name, symbol: symbols.player2, fieldSize: fieldSize)
        printField(fieldSize: fieldSize)
        if let symbol = checkPlayerWon() {
            winnerSymbol = symbol
            break
        }
        if checkIfGameOver() {
            break
        }
        
        if winnerSymbol == symbols.player1 {
            print("победил: \(player1Name)")
        } else if winnerSymbol == symbols.player2 {
            print("победил: \(player2Name)")
        } else {
            print("игра окончилась вничью")
        }
        
        let shouldStartNewGame = getDataFromUser(description: "если хотите начать новую игру введите да")
        if shouldStartNewGame != "да" {
            exit(0)
        }
    }
}


func checkPlayerWon() -> String? {
    checkPlayerWonByRows()
    ?? checkPlayerWonByColumn()
    ?? checkPlayerWonByFirstDiagonal()
    ?? checkPlayerWonBySecondDiagonal()
}

func playerTurn(playerName: String, symbol: String, fieldSize: Int) {
    while true {
        print("\(playerName) делае ход: ")
        let row = getDataFromUser(description: "Введите номер строки")
        guard let row = Int(row), row > 0, row <= fieldSize else {
            print("введен неверный номер строки")
            continue
        }
        let column = getDataFromUser(description: "Введите номер столбца")
        guard let column = Int(column), column > 0, column <= fieldSize else {
            print("введен неверный номер столбца")
            continue
        }
        let fieldRow = row - 1
        let fieldColumn = column - 1
        guard field[fieldRow][fieldColumn] == symbols.empty else {
            print("такой ход уже был")
            continue
        }
        field[fieldRow][fieldColumn] = symbol
        break
    }
}

func getDataFromUser(description: String) -> String {
    print(description)
    return readLine() ?? ""
}

func printField(fieldSize: Int) {
    var fieldFormatedString = ""
    for row in field {
        fieldFormatedString += "|"
        for cell in row {
            fieldFormatedString += cell + "|"
        }
        fieldFormatedString += "\n"
        for _ in 0..<(fieldSize*2+1) {
            fieldFormatedString += "_"
        }
        fieldFormatedString += "\n"
    }
    print(fieldFormatedString)
}

func checkIfGameOver() -> Bool {
    for row in field {
        for cell in row {
            if cell == symbols.empty {
                return false
            }
        }
        }
    return true
    }

func checkPlayerWonByRows() -> String? {
    let fieldSize = field.count
    for i in 0..<fieldSize {
        let firstSymbol = field[i][0]
        if firstSymbol == symbols.empty {
            return nil
        }
        var isWin = true
        for j in 0..<fieldSize {
            if field[i][j] != firstSymbol {
                isWin = false
                break
            }
        }
        if isWin {
            return firstSymbol
        }
    }
    return nil
}

func checkPlayerWonByColumn() -> String? {
    let fieldSize = field.count
    for i in 0..<fieldSize {
        let firstSymbol = field[0][i]
        if firstSymbol == symbols.empty {
            return nil
        }
        var isWin = true
        for j in 0..<fieldSize {
            if field[j][i] != firstSymbol {
                isWin = false
                break
            }
        }
        if isWin {
            return firstSymbol
        }
    }
    return nil
}

func checkPlayerWonByFirstDiagonal() -> String? {
    let fieldSize = field.count
    let firstSymbol = field[0][0]
    
    guard firstSymbol != symbols.empty else {
        return nil
    }
    var isWin = true
    for i in 0..<fieldSize {
        if field[i][i] != firstSymbol {
            isWin = false
            break
        }
    }
    if isWin {
        return firstSymbol
    }
    return nil
}

func checkPlayerWonBySecondDiagonal() -> String? {
    let fieldSize = field.count
    let lastIndex = fieldSize - 1
    let firstSymbol = field[0][lastIndex]
    
    guard firstSymbol != symbols.empty else {
        return nil
    }
    var isWin = true
    for i in 0..<fieldSize {
        if field[i][lastIndex - i] != firstSymbol {
            isWin = false
            break
        }
    }
    if isWin {
        return firstSymbol
    }
    return nil
}
