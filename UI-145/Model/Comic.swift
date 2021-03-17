//
//  Comic.swift
//  UI-145
//
//  Created by にゃんにゃん丸 on 2021/03/17.
//

import SwiftUI

struct  APIComicResults : Codable {

    var data : APIComicData
}

struct APIComicData : Codable {
    var count :Int
    var results : [Comic]
}

struct Comic: Identifiable,Codable {
    
    var id : Int
    var title : String
    var description : String?
    var thumbnail : [String:String]
    var urls : [[String:String]]
   
}

