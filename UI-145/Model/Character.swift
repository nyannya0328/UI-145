//
//  Character.swift
//  UI-145
//
//  Created by にゃんにゃん丸 on 2021/03/17.
//

import SwiftUI

struct  ApiResults : Codable {

    var data : APICharacterData
}

struct APICharacterData : Codable {
    var count :Int
    var results : [Character]
}

struct Character: Identifiable,Codable {
    
    var id : Int
    var name : String
    var description : String
    var thumbnail : [String:String]
    var urls : [[String:String]]
   
}

