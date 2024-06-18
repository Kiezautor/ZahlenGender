//
//  PlayerSetupView.swift
//  ZahlenGender
//
//  Created by Markus Zemke on 18.06.24.
//

import SwiftUI

// View for setting up players
struct PlayerSetupView: View {
    @ObservedObject var game: Game
    @State private var playerName: String = ""
    @State private var playerAge: String = ""
    @State private var playerGender: Gender = .na

    var body: some View {
        VStack {
            Text("Spieler erstellen")
                .font(.largeTitle)

            TextField("Name", text: $playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Alter", text: $playerAge)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)

            Picker("Geschlecht", selection: $playerGender) {
                Text("Männlich").tag(Gender.male)
                Text("Weiblich").tag(Gender.female)
                Text("Divers").tag(Gender.divers)
                Text("Keine Angabe").tag(Gender.na)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Spieler hinzufügen") {
                if let age = Int(playerAge), age > 0 && age <= 120 {
                    let player = Player(name: playerName, gender: playerGender, age: age)
                    game.addPlayer(player)
                    playerName = ""
                    playerAge = ""
                    playerGender = .na
                }
            }
            .padding()

            if game.players.count > 0 {
                Button("Spiel starten") {
                    game.startGame()
                }
                .padding()
            }
        }
        .padding()
    }
}
