//
//  Game.swift
//  ZahlenGender
//
//  Created by Markus Zemke on 17.06.24.
//

import Foundation

class Game: ObservableObject {
    @Published var players: [Player]
    @Published var round: Int = 0
    @Published var message: String = ""
    @Published var currentPlayerIndex: Int = 0
    @Published var showScore: Bool = false
    @Published var highscore: Int = UserDefaults.standard.integer(forKey: "highscore")

    init(players: [Player]) {
        self.players = players
    }

    var currentPlayer: Player? {
        if players.isEmpty { return nil }
        return players[currentPlayerIndex]
    }

    func addPlayer(_ player: Player) {
        players.append(player)
    }

    func startGame() {
 //       round = 1
        currentPlayerIndex = 0
        message = "Start!"
        nextRound()
    }

    func nextRound() {
        guard !players.isEmpty else { return }
        showScore = false
        let youngestPlayer = players.min(by: { $0.age < $1.age })!
        let maxRandomNumber = calculateMaxRandomNumber(for: youngestPlayer)
        let randomNumber = Int.random(in: 1...maxRandomNumber)
        for index in players.indices {
            players[index].randomNumber = randomNumber
            players[index].attemptsLeft = 10
        }
        round += 1
        message = "Errate eine Zahl zwischen 1 und \(maxRandomNumber)."
        currentPlayerIndex = 0
    }

    func calculateMaxRandomNumber(for player: Player) -> Int {
        let baseNumber = 100
        switch player.gender {
        case .male:
            return baseNumber + Int((Double(round) - 1) * (0.5 * Double(player.age)))
        case .female:
            return baseNumber + Int((Double(round) - 1) * (0.75 * Double(player.age)))
        case .divers:
            return baseNumber + Int((Double(round) - 1) * Double(player.age))
        case .na:
            return baseNumber + Int((Double(round) - 1) * (2 * Double(player.age)))
        }
    }

    func makeGuess(_ guess: Int) {
        guard let currentPlayer = currentPlayer else { return }
        if guess == currentPlayer.randomNumber {
            message = "Richtig! \(currentPlayer.name) hat die richtige Zahl erraten."
            updatePlayerScore(currentPlayer.id, points: 10)
            showScore = true
        } else {
            message = guess < currentPlayer.randomNumber ? "Zu niedrig!" : "Zu hoch!"
            updatePlayerAttemptsAndScore(currentPlayer.id, correct: false)
            showScore = false
            
            if currentPlayer.score <= 0 {
                message = "Leider hast du alle Punkte verloren."
                players.removeAll { $0.id == currentPlayer.id }
                if players.isEmpty {
                    message = "Alle Spieler haben verloren. Spiel ist vorbei."
                    showScore = true
                    return
                }
                showScore = true
            } else if currentPlayer.attemptsLeft == 0 {
                message = "Leider hast du alle Versuche aufgebraucht."
                if currentPlayer.score > highscore {
                    highscore = currentPlayer.score
                }
                players.removeAll { $0.id == currentPlayer.id }
                if players.isEmpty {
                    message = "Alle Spieler haben verloren. Spiel ist vorbei."
                    showScore = true
                    return
                } else {
                    nextPlayer()
                }
            }
        }

        if !showScore && currentPlayer.attemptsLeft > 0 {
            nextPlayer()
        }
    }

    func nextPlayer() {
        currentPlayerIndex += 1
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
   //         round += 1
   //         showScore = true
        }
    }
    
    private func updatePlayerScore(_ id: UUID, points: Int) {
        if let index = players.firstIndex(where: { $0.id == id }) {
            players[index].score += points
            if players[index].score > highscore {
               highscore = players[index].score
                UserDefaults.standard.setValue(highscore, forKey: "highscore")
            }
        }
    }
    
    private func updatePlayerAttemptsAndScore(_ id: UUID, correct: Bool) {
        if let index = players.firstIndex(where: { $0.id == id }) {
            players[index].attemptsLeft -= 1
            players[index].score -= 1
        }
    }
}
