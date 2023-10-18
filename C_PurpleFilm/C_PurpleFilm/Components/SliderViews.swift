//
//  ShapedViews.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/21.
//

import SwiftUI

struct TriangleView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        return path
    }
}

struct TriangleViewSpecific: View{
  let width: CGFloat
  let isUp: Bool
  
  var body: some View{
    
    return HStack{
      
      if isUp == true{
        Spacer()
          .frame(width: width)
      }
     
      TriangleView()
        .foregroundColor(.grayButton)
        .frame(width: 21, height: 19)
        .cornerRadius(3)
        .offset(y: -15)
      
      if isUp == false{
        Spacer()
          .frame(width: width)
      }
    }
  }
}


struct CenterOriginSliderSpecific: View{
  
  var minValue: Float
  var maxValue: Float
  var increment: Float
  @Binding var sliderValue: Float
  
  var body: some View{
    return HStack(spacing: 0){
      CenterOriginSlider(
        minValue: self.minValue,
        maxValue: self.maxValue,
        increment: self.increment,
        sliderValue: $sliderValue,
        thumbSize: 16,
        thumbColor: .white,
        guideBarCornerRadius: 0,
        guideBarColor: Color(hex: 0xB1B1B1),
        guideBarHeight: 4,
        trackingBarColor: Color(hex: 0xB367FF),
        trackingBarHeight: 4
      )
      .frame(width: 250, height: 20)
      Text("\(Int(sliderValue*100))")
        .frame(width: 40)
    }
    .padding([.trailing, .leading], 10)
  }
}
