//
//  CustomViews.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/29.
//

import SwiftUI

struct FilterTextView: View{
  let title: String
  let filterNum: Int
  let currentNum: Int
  
  var body: some View{
    return Text(title)
      .font(.system(size: 12, weight: filterNum == currentNum ? .bold : .regular))
      .foregroundColor(Color(hex: filterNum == currentNum ? 0xB367FF : 0x747474))
      .padding(.all, 5)
      .background(filterNum == currentNum ? Color(hex: 0xD9C2F0): .clear)
      .cornerRadius(5)
  }
}
