//
//  ImageView.swift
//  C_PurpleFilm
//
//  Created by yun on 10/6/23.
//

import SwiftUI

struct ImageView: View {

  let uiImage: UIImage
  
  let brightness: Float
  let contrast: Float
  let saturation: Float
  
  let textOnImg: String
  let fontName: String
  let fontSize: CGFloat
  let fontColor: Int
  let grainStyle: String
  let filterType: String
  
  
  
  var isTextOn: Bool = false
  
  init(uiImage: UIImage){
    self.uiImage = uiImage
    self.textOnImg = ""
    self.fontName = "ChosunilboNM"
    self.fontSize = 20
    self.fontColor = 0x000000
    self.brightness = 0
    self.contrast = 0
    self.saturation = 0
    self.grainStyle = "grain0"
    self.filterType = "none"
  }
  
  init(uiImage: UIImage, brightness: Float, contrast: Float, saturation: Float, textOnImg: String, fontName: String, fontSize: CGFloat, fontColor: Int, grainStyle: String, filterType: String){
    self.uiImage = uiImage
    self.textOnImg = textOnImg
    self.fontName = fontName
    self.fontSize = fontSize
    self.fontColor = fontColor
    self.brightness = brightness
    self.contrast = contrast
    self.saturation = saturation
    self.grainStyle = grainStyle
    self.filterType = filterType
  }
  
  
  
  var body: some View {
    ZStack{
      Image(uiImage: uiImage)
        .resizable()
        
        .scaledToFill()
        
        .frame(width: UIScreen.screenWidth,
               height: UIScreen.screenWidth*9/16)
        .clipped()
        .brightness(Double(brightness))
        .contrast(Double(contrast+1))
        .saturation(Double(saturation+1))
        
        .overlay {
          if grainStyle == "grain0"{
            EmptyView()
          }else{
            Image(grainStyle)
              
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: UIScreen.screenWidth,
                     height: UIScreen.screenWidth*9/16)
              .opacity(0.4)
          }
        }
        .overlay(content: {
          if filterType == "none"{
            EmptyView()
          }else{
            Image(filterType)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: UIScreen.screenWidth,
                     height: UIScreen.screenWidth*9/16)
              .clipped()
              .opacity(0.3)
          }
        })
        
      
      VStack{
        Spacer()
        
          Text(textOnImg)
            .font(Font.custom(fontName, size: fontSize))
            .foregroundColor(Color(hex: fontColor))
            .multilineTextAlignment(.center)
            .padding()
        }
    }
    .frame(width: UIScreen.screenWidth,
           height: UIScreen.screenWidth*9/16)
  }
}
