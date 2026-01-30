//
//  Emojis.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

enum Emojis: String, CaseIterable, Codable {
    case smilingFace = "🙂"
    case heartEyesCat = "😻"
    case hibiscus = "🌺"
    case dogFace = "🐶"
    case redHeart = "❤️"
    case screamingFace = "😱"
    case smilingFaceWithHalo = "😇"
    case angryFace = "😡"
    case coldFace = "🥶"
    case thinkingFace = "🤔"
    case raisingHands = "🙌"
    case hamburger = "🍔"
    case broccoli = "🥦"
    case pingPong = "🏓"
    case firstPlaceMedal = "🥇"
    case guitar = "🎸"
    case desertIsland = "🏝"
    case sleepyFace = "😪"
    
    static func getEnum(fromString: String) -> Emojis {
        Emojis.allCases.first(where: { $0.rawValue == fromString }) ?? .smilingFace
    }
}
