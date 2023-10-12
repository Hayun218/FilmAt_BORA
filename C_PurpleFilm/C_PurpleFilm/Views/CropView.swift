//
//  CropView.swift
//  C_PurpleFilm
//
//  Created by yun on 10/9/23.
//

import SwiftUI

import ComposableArchitecture

struct CropView: View {
  
  let uiImage: UIImage
  
  let brightness: Float
  let contrast: Float
  let saturation: Float
  
  let textOnImg: String
  let fontName: String
  let fontSize: CGFloat
  let fontColor: Int
  
  @GestureState var isInteracting:Bool = false
  @State var isLong:Bool = false
  
  let store: StoreOf<CropViewFeature>
  
  @ObservedObject var viewStore: ViewStoreOf<CropViewFeature>
  
  init(store: StoreOf<CropViewFeature>, uiImage: UIImage, brightness: Float, contrast: Float, saturation: Float, textOnImg: String, fontName: String, fontSize: CGFloat, fontColor: Int){
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
    
    self.uiImage = uiImage
    self.textOnImg = textOnImg
    self.fontName = fontName
    self.fontSize = fontSize
    self.fontColor = fontColor
    self.brightness = brightness
    self.contrast = contrast
    self.saturation = saturation
  }
  
  init(store: StoreOf<CropViewFeature>, uiImage: UIImage){
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
    self.uiImage = uiImage
    self.textOnImg = ""
    self.fontName = "ChosunilboNM"
    self.fontSize = 20
    self.fontColor = 0x000000
    self.brightness = 0
    self.contrast = 0
    self.saturation = 0
  }
  
  var body: some View {
    
    
    ZStack{
      CropImageView()
      
      VStack{
        Spacer()
          .frame(width: UIScreen.screenWidth)
          .background(.black)
          .opacity(0.3)
        
        Spacer()
          .frame(width: UIScreen.screenWidth,
                 height: UIScreen.screenWidth/16*9)
        
        
        Spacer()
          .frame(width: UIScreen.screenWidth)
          .background(.black)
          .opacity(0.3)
        
      }
      
    }
    .onAppear(perform: {
      if uiImage.size.height > uiImage.size.width{
        isLong = true
      }
    })
    .padding([.top], 17)
    .frame(width: UIScreen.screenWidth, height: isLong ? UIScreen.screenHeight/1.4 : UIScreen.screenHeight/2.5)
    .position(x: UIScreen.main.bounds.width/2,
              y: isLong ? UIScreen.screenHeight/3 :UIScreen.main.bounds.height/4.5)
   
  }
  
  @ViewBuilder
  func CropImageView() -> some View{
    GeometryReader{
      let size = $0.size
      Image(uiImage: uiImage)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: size.width, height: size.height)
        .overlay(content: {
          GeometryReader{ proxy in
            let rect = proxy.frame(in: .named("CROPVIEW"))
            
            Color.clear
              .onChange(of: isInteracting) { newValue in
                
                print("rectMinX\(rect.minX)")
                print("offsetW\(viewStore.lastStoredOffset.width)")
                viewStore.send(.keepInBorder(rect))
                print("rectMinX\(rect.minX)")
                print("offsetW\(viewStore.lastStoredOffset.width)")
              }
          }
        })
        .brightness(Double(brightness))
        .contrast(Double(contrast+1))
        .saturation(Double(saturation+1))
    }
    .scaleEffect(viewStore.scale)
    .offset(viewStore.offset)
    
    .overlay {
      GridCropView()
        .frame(width: UIScreen.screenWidth,
               height: UIScreen.screenWidth/16*9)
    }
    .coordinateSpace(name: "CROPVIEW")
   
    .gesture(
      DragGesture()
        .updating($isInteracting, body: {_,out,_ in
          out = true
        })
        .onChanged({value in
          let translation = value.translation
          viewStore.send(.offsetChanged(translation))
        })
//        .onEnded({ _ in
//          viewStore.send(.saveOffset)
//        })
      
    )
    .gesture(MagnificationGesture()
      .updating($isInteracting, body: {_, out, _ in
        out = true
      }).onChanged({ value in
        viewStore.send(.scaleChanged(value))
      })
        .onEnded({ value in
          viewStore.send(.scaleAdjust)
        })
    )
//    .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth/16*9)
  
    
  }
}
