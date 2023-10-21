//
//  CustomViews.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/29.
//

import SwiftUI

// MARK: - MovieView Filter Text
struct FilterTextView: View{
  let title: String
  let filterType: String
  let currentFilterType: String
  
  var body: some View{
    let isNow: Bool = filterType == currentFilterType
    
    return Text(title)
      .font(.system(size: 12, weight: isNow ? .bold : .regular))
      .foregroundColor(Color(hex: isNow ? 0xB367FF : 0x747474))
      .padding(.all, 5)
      .background(isNow ? Color(hex: 0xD9C2F0): .clear)
      .cornerRadius(2)
  }
}

// MARK: - Buttons
struct ButtonLabel: View{
  let img: String
  let isSelected: Bool
  let text: String
  
  var body: some View{
    return VStack{
      Image(systemName: img)
        .foregroundColor(isSelected ? .accent100 : .black)
        .frame(width: 60, height: 60)
        .background(.grayButton)
        .clipShape(Circle())
      
      Text(text)
        .font(.system(size: 9))
        .foregroundColor(.gray200)
    }
  }
}

// MARK: - Buttons with Selection
struct ButtonLabelWithOverlay: View {
  let img: String
  let text: String
  let index: Int
  
  var body: some View {
    return VStack{
      Image(systemName: img)
        .foregroundColor(.black)
        .frame(width: 60, height: 60)
        .background(.grayButton)
        .clipShape(Circle())
        .overlay(
          RoundedRectangle(cornerRadius: 100)
          .inset(by: 4)
          .trim(from: 0, to: CGFloat(0.35))
          .stroke(.accent50, lineWidth: 5)
          .rotationEffect(.degrees(Double(index)*10))
        )
      
      Text(text)
        .font(.system(size: 10))
        .foregroundColor(.gray200)
    }
  }
}

// MARK: - CropView Grid
struct GridCropView: View{
  var body: some View{
    return  ZStack{
      HStack{
        ForEach(1...3, id:\.self){ _ in
          Rectangle()
            .fill(.white.opacity(0.5))
            .frame(width: 1)
            .frame(maxWidth: .infinity)
        }
      }
      VStack{
        ForEach(1...3, id:\.self){_ in
          Rectangle()
            .fill(.white.opacity(0.5))
            .frame(height: 1)
            .frame(maxHeight: .infinity)
        }
      }
    }
  }
}
