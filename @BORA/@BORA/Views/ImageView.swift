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
  let fontType: Int
  let grainStyle: String
  let filterType: String
  
  let offset: CGSize
  
  
  var isTextOn: Bool = false
  
  init(uiImage: UIImage, offset: CGSize){
    self.uiImage = uiImage
    self.textOnImg = ""
    self.fontName = "ChosunilboNM"
    self.fontSize = 20
    self.fontType = 1
    self.brightness = 0
    self.contrast = 0
    self.saturation = 0
    self.grainStyle = "grain0"
    self.filterType = "none"
    self.offset = offset
  }
  
  init(uiImage: UIImage){
    self.uiImage = uiImage
    self.textOnImg = ""
    self.fontName = "ChosunilboNM"
    self.fontSize = 20
    self.fontType = 1
    self.brightness = 0
    self.contrast = 0
    self.saturation = 0
    self.grainStyle = "grain0"
    self.filterType = "none"
    self.offset = .zero
  }

  
  init(uiImage: UIImage, brightness: Float, contrast: Float, saturation: Float, textOnImg: String, fontName: String, fontSize: CGFloat, fontType: Int, grainStyle: String, filterType: String){
    self.uiImage = uiImage
    self.textOnImg = textOnImg
    self.fontName = fontName
    self.fontSize = fontSize
    self.fontType = fontType
    self.brightness = brightness
    self.contrast = contrast
    self.saturation = saturation
    self.grainStyle = grainStyle
    self.filterType = filterType
    self.offset = .zero
  }
  
  
  
  var body: some View {
    ZStack{
      Image(uiImage: uiImage)
        .resizable()
      
        .scaledToFill()
        .offset(offset)
      
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
        if fontType == 2{
          
          Text(textOnImg)
            .font(Font.custom(fontName, size: fontSize))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(5)
            .background(content: {
              RoundedRectangle(cornerRadius: 3)
                .fill(.white)
                .opacity(0.3)
            }).padding(5)
          
            
        }
        else if fontType == 3{
          let width = 0.5
          ZStack{
            ZStack{
              Text(textOnImg).offset(x:  width, y:  width)
              Text(textOnImg).offset(x: -width, y: -width)
              Text(textOnImg).offset(x: -width, y:  width)
              Text(textOnImg).offset(x:  width, y: -width)
            }
            .font(Font.custom(fontName, size: fontSize))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            Text(textOnImg)
              .font(Font.custom(fontName, size: fontSize))
              .foregroundColor(.white)
              .multilineTextAlignment(.center)
            

          }              .padding(5)
                
        }
        
      }
      
    }
    .frame(width: UIScreen.screenWidth,
           height: UIScreen.screenWidth*9/16)
  }
}
