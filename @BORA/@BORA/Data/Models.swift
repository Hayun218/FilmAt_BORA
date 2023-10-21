//
//  Models.swift
//  C_PurpleFilm
//
//  Created by yun on 10/16/23.
//

import Foundation

// MARK: - MovieView
enum movieOpt: String, CaseIterable{
  case fontStyle = "fontStyle"
  case textSize = "textSize"
  case textStyle = "textStyle"
  case grain = "grain"
}

enum filterStyle: String{
  case filterZero = "none"
  case filterOne = "Lavendar"
  case filterTwo = "Lilac"
  case filterThree = "Plum"
  case filterFour = "Violet"
  case filterFive = "Mouve"
}


// MARK: - EditView
enum editOpt: String, CaseIterable{
  case brightness = "brightness"
  case contrast = "contrast"
  case saturation = "saturation"
  case sharpen = "sharpen"
}
