//
//  GameView.swift
//  ZahlenGender
//
//  Created by Markus Zemke on 18.06.24.
//

import SwiftUI

// View for playing the game
struct GameView: View {
    @ObservedObject var game: Game
    @State private var currentGuess: String = ""

    var body: some View {
        VStack {
            Text("Runde \(game.round)")
                .font(.largeTitle)

            if let currentPlayer = game.currentPlayer {
                Text("\(currentPlayer.name) ist dran")
                    .font(.headline)
                    .padding()

                TextField("Schätzung", text: $currentGuess)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.numberPad)

                Button("Schätzen") {
                    if let guess = Int(currentGuess) {
                        game.makeGuess(guess)
                        currentGuess = ""
                    }
                }
                .padding()

                Text(game.message)
                    .padding()
            } else {
                Text("Spiel vorbei!")
                    .font(.largeTitle)
            }
        }
        .padding()
    }
}
