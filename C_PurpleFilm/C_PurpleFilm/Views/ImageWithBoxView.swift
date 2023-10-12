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
  let fontColor: Int
  
  let grainStyle: String
  let filterType: String
  
  
  var body: some View {
    
    
    
    ZStack{
 
      
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
                  fontSize: fontSize, fontColor: fontColor,
                  grainStyle: grainStyle,filterType: filterType
        )
      }
      VStack{
        Spacer()
        Text(textOnImg)
          .font(Font.custom(fontName, size: fontSize))
          .foregroundColor(.white)
          .multilineTextAlignment(.center)
          .padding()
      }
      .padding()
      
      
      
      
      
    }
  }
}
