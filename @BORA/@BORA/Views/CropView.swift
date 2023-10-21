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
  
  @GestureState var isInteracting:Bool = false
  @State var isLong: Bool = false
  @State var ratio: CGFloat = 0
  
  let store: StoreOf<CropViewFeature>
  
  @ObservedObject var viewStore: ViewStoreOf<CropViewFeature>
  
  init(store: StoreOf<CropViewFeature>, uiImage: UIImage){
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
    
    self.uiImage = uiImage
  }
  
  var body: some View {
    
    ZStack{
      CropImageView()
        .frame(maxWidth: .infinity, maxHeight: UIScreen.screenWidth*4/3)
        .clipped()
        .contentShape(Rectangle())
      
      VStack{
        Spacer()
          .frame(width: UIScreen.screenWidth)
          .background(.black)
          .opacity(0.3)
        
        Spacer()
          .frame(width: UIScreen.screenWidth,
                 height: UIScreen.screenWidth*9/16)
        
        Spacer()
          .frame(width: UIScreen.screenWidth)
          .background(.black)
          .opacity(0.3)
        
      }
    }
    .onAppear(perform: {
      ratio = uiImage.size.height/uiImage.size.width
      if uiImage.size.height > uiImage.size.width{
        isLong = true
      }
      
    })
    .padding([.top], 17)
    // MARK: 스크린캡쳐 비율 handle을 위해 고정 값으로 진행 => 차후 변경
    // .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth*ratio)
    .frame(maxWidth: .infinity, maxHeight: UIScreen.screenWidth*4/3)
    .position(x: UIScreen.main.bounds.width/2,
              y: UIScreen.screenHeight/3) //:UIScreen.main.bounds.height/4.5)
    
  }
  
  @ViewBuilder
  func CropImageView() -> some View{
    GeometryReader{
      let size = $0.size
      Image(uiImage: uiImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
      
        .overlay(content: {
          GeometryReader{ proxy in
            let rect = proxy.frame(in: .named("CROPVIEW"))
            
            Color.clear
              .onChange(of: isInteracting) { newValue in
                viewStore.send(.keepInBorder(rect))
                if !newValue{
                  viewStore.send(.saveOffset)
                }
              }
          }
        })
        .frame(width: size.width, height: size.height)
    }
    
    .scaleEffect(viewStore.scale)
    .offset(viewStore.offset)
    
    .overlay {
      GridCropView()
      
        .frame(width: UIScreen.screenWidth,
               height: UIScreen.screenWidth*9/16)
        .coordinateSpace(name: "CROPVIEW")
    }
    
    .gesture(
      DragGesture()
        .updating($isInteracting, body: {_,out,_ in
          out = true
        })
        .onChanged({value in
          let translation = value.translation
          
          viewStore.send(.offsetChanged(translation))
        })
    )
    // MARK: - Scale Gesture (보류)
    //        .gesture(MagnificationGesture()
    //          .updating($isInteracting, body: {_, out, _ in
    //            out = true
    //          }).onChanged({ value in
    //            viewStore.send(.scaleChanged(value))
    //          })
    //            .onEnded({ value in
    //              viewStore.send(.scaleAdjust)
    //            })
    //        )
    .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth*ratio)
  }
}
