//
//  BackImages.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/20.
//
// MARK: FilmView Img & Text Data

import SwiftUI

struct ImageStore: Identifiable {
  var name: String
  var id: Int
}

struct BackImages{
  
  let bgImages: [ImageStore] = [
    ImageStore(name:"flower",id:0),
    ImageStore(name:"Sodis", id:1),
    ImageStore(name:"Hwang1", id:2),
    ImageStore(name:"Uhmamooshi", id:3),
    ImageStore(name:"Llow", id:4),
    ImageStore(name:"Chung", id:5),
    ImageStore(name:"ReCiel", id:6),
    ImageStore(name:"BosQue", id: 7),
  ]
  
  let bgLocation: [String] = [
    "Pink Muhly",
    "SODIS",
    "Hwangridan-gil",
    "UHMAMOOSHI",
    "LLOW",
    "청수당",
    "LE CIEL",
    "BOSQUE"
  ]
  
  let bgTexts: [String] = [
    "💕 첨성대 앞\n\n🌸 가을 풍경\n\n🎀",
    "☕️ 소디스 본점\n\n🛣️ 도로 위\n\n☘️ 숲 뷰",
    "🌄 황리단길\n\n🧸 소품샵\n\n🏬",
    "☕️ 경주 카페\n\n🍫 티라미수 맛집\n\n🍞 어마무시",
    "☕️ 경주 카페\n\n🪟 유리 창문\n\n🌊 보문호 뷰",
    "🌄 황리단길\n\n☕️ 카페\n\n🌲 나무 사이",
    "☕️ 경주 카페\n\n💦 물 인테리어\n\n🏠 르씨엘",
    "☕️ 경주 카페\n\n🍰 딸기케익 맛집\n\n🏢 보스케",
  ]
}
