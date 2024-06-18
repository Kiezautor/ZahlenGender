//
//  ContentView.swift
//  ZahlenGender
//
//  Created by Markus Zemke on 17.06.24.
//
// TODO: Emailanmeldung mit Firebase
// TODO: Erstellen eines Profils
// TODO: Erstellen eines Onlineraums
// TODO: Mehrspielermodus mit anderen Handys
// TODO: Chatfunktion während des Spiels

import SwiftUI

struct ContentView: View {
    @StateObject var game = Game(players: [])
    @State private var playerName: String = ""
    @State private var playerGender: String = "M"
    @State private var playerAge: String = ""
    @State private var guess: String = ""
    @State private var showGameScreen = false

    var body: some View {
        VStack {
            if !showGameScreen {
                VStack {
                    Text("Highscore: \(game.highscore)\n\n")
                    TextField("Spielername", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Geschlecht (M/W/D/N)", text: $playerGender)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Alter", text: $playerAge)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()

                    Button("Spieler hinzufügen") {
                        if let age = Int(playerAge), age > 0, age <= 120 {
                            let gender: Gender
                            switch playerGender.uppercased() {
                            case "M":
                                gender = .male
                            case "W":
                                gender = .female
                            case "D":
                                gender = .divers
                            case "N":
                                gender = .na
                            default:
                                gender = .na
                            }
                            let player = Player(name: playerName, gender: gender, age: age)
                            game.addPlayer(player)
                            playerName = ""
                            playerGender = "M"
                            playerAge = ""
                        }
                    }
                    .padding()

                    if !game.players.isEmpty {
                        Button("Spiel starten") {
                            showGameScreen = true
                            game.startGame()
                        }
                        .padding()
                    }

                    List(game.players) { player in
                        Text("\(player.name), \(player.age) Jahre alt, Geschlecht: \(player.gender)")
                    }
                }
                .padding()
            } else {
                VStack {
                    Text("Highscore: \(game.highscore)")
                    Spacer()
                    Text("Runde \(game.round)")
                    Text(game.message)
                    if game.showScore {
                        VStack {
                            Text("Zwischenstand:")
                            ForEach(game.players) { player in
                                Text("\(player.name): \(player.score) Punkte")
                            }
                            Button("Nächste Runde") {
                                game.showScore = false
                                game.nextRound()
                            }
                            .padding()
                        }
                    } else if let currentPlayer = game.currentPlayer {
                        Text("Aktueller Spieler: \(currentPlayer.name)")
                        TextField("Deine Schätzung", text: $guess)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button("Schätzen") {
                            if let guessNumber = Int(guess) {
                                game.makeGuess(guessNumber)
                                guess = ""
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
    }
}
