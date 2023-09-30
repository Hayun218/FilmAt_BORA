//
//  BackImages.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/20.
//

import SwiftUI

struct ImageStore: Identifiable {
    var name: String
    var id: Int
}

struct BackImages{
  
  let bgImages: [ImageStore] = [
    ImageStore(name:"BosQue",id:0),
    ImageStore(name:"Sodis",id:1),
  ]
  
  let bgTexts: [String] = [
  "BosQue isddddfsdfadfasdfasdfasdf",
  "BosQue isddddfsdfadfasdfasdfasdf",
  "BosQue isddddfsdfadfasdfasdfasdf",
  ]
  
  let bgLocation: [String] = [
    "dddd",
    "dddd",
    "dddd",
  ]
}
