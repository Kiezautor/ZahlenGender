//
//  Player.swift
//  ZahlenGender
//
//  Created by Markus Zemke on 17.06.24.
//

import Foundation

struct Player: Identifiable {
    var id = UUID()
    var name: String
    var score: Int = 10
    var gender: Gender
    var randomNumber: Int = 0
    var attemptsLeft: Int = 10
    private var _age: Int = 0

    var age: Int {
        get { _age }
        set {
            if newValue > 0 && newValue <= 120 {
                _age = newValue
            }
        }
    }

    init(name: String, gender: Gender, age: Int) {
        self.name = name
        self.gender = gender
        self.age = age
    }
}

enum Gender {
    case male, female, divers, na
}
