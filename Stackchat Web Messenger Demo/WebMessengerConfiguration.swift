//
//  WebMessengerConfiguration.swift
//  Stackchat Web Messenger Demo
//
//  Created by Parth Mehta on 8/7/20.
//  Copyright © 2020 Parth Mehta. All rights reserved.
//
//  To parse the JSON, add this file to your project and do:
//
//  let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WebMessengerConfig
struct WebMessengerConfig: Codable {
    let personaMap: [String: String]
    let customColors: CustomColors
    let businessIconURL: String
    let businessName: String
    let buttonIconURL, defaultAvatarURL: String
    let buttonWidth, buttonHeight: String
    let initialGreeting: InitialGreeting

    enum CodingKeys: String, CodingKey {
        case personaMap, customColors
        case businessIconURL = "businessIconUrl"
        case businessName
        case buttonIconURL = "buttonIconUrl"
        case defaultAvatarURL = "defaultAvatarUrl"
        case buttonWidth, buttonHeight, initialGreeting
    }
}

// MARK: - CustomColors
struct CustomColors: Codable {
}

// MARK: - InitialGreeting
struct InitialGreeting: Codable {
    let messages, actions: [String]
}
