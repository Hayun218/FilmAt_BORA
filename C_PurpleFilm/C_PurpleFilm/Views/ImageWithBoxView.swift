//
//  ImageWithBoxView.swift
//  C_PurpleFilm
//
//  Created by yun on 10/6/23.
//

import SwiftUI

struct ImageWithBoxView: View {
  let uiImage: UIImage
  let isOriginal: Bool
  let originalUIImage: UIImage?
  
  let brightness: Float
  let contrast: Float
  let saturation: Float
  
  let textOnImg: String
  let fontName: String
  let fontSize: CGFloat
  let fontType: Int
  
  let grainStyle: String
  let filterType: String
  
  init(uiImage: UIImage, isOriginal: Bool, originalUIImage: UIImage){
    self.uiImage = uiImage
    self.isOriginal = isOriginal
    self.originalUIImage = originalUIImage
    self.textOnImg = ""
    self.fontName = "ChosunilboNM"
    self.fontSize = 20
    self.fontType = 1
    self.brightness = 0
    self.contrast = 0
    self.saturation = 0
    self.grainStyle = "grain0"
    self.filterType = "none"
  }
  init(uiImage: UIImage, brightness: Float, contrast: Float, saturation: Float, textOnImg: String, fontName: String, fontSize: CGFloat, fontType: Int, grainStyle: String, filterType: String){
    self.uiImage = uiImage
    self.isOriginal = false
    self.originalUIImage = nil
    self.textOnImg = textOnImg
    self.fontName = fontName
    self.fontSize = fontSize
    self.fontType = fontType
    self.brightness = brightness
    self.contrast = contrast
    self.saturation = saturation
    self.grainStyle = grainStyle
    self.filterType = filterType
  }
  
  
  
  var body: some View {
    
    
    ZStack{
      // Letter Box
      Spacer()
        .frame(width: UIScreen.screenWidth,
               height: UIScreen.screenWidth*3/4)
        .background(.black)
      
      
      if isOriginal {
        if let originalUIImage = originalUIImage{
          ImageView(uiImage: originalUIImage)
        }
        
      }else{
        ImageView(uiImage: uiImage,
                  brightness: brightness, contrast: contrast, saturation: saturation,
                  textOnImg: textOnImg, fontName: fontName,
                  fontSize: fontSize, fontType: fontType,
                  grainStyle: grainStyle,filterType: filterType
        )
      }
      if fontType == 1{
        VStack{
          Spacer()
          Text(textOnImg)
            .font(Font.custom(fontName, size: fontSize))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
        }
        .padding(10)
      }
    }
    .frame(width: UIScreen.screenWidth,
           height: UIScreen.screenWidth*3/4)
  }
}
