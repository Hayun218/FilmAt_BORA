////
////  EditFilmView.swift
////  C_PurpleFilm
////
////  Created by yun on 2023/09/17.
////
//
//import Foundation


//enum editOpt: String, CaseIterable{
//  case brightness = "brightness"
//  case exposure = "exposure"
//  case contrast = "contrast"
//  case saturation = "saturation"
//}
//
//
//VStack{
//  
//  VStack{
//    Image(uiImage: viewStore.editedImage)
//      .resizable()
//      .aspectRatio(contentMode: .fit)
//    
//    
//      .frame(width: UIScreen.main.bounds.width ,height: viewStore.state.isSize16 ? UIScreen.main.bounds.width/16*9 : UIScreen.main.bounds.width/21*9)
//      .clipped()
//      .background(.black)
//  }.frame(height: UIScreen.main.bounds.height/3)
//    .offset(y: UIScreen.main.bounds.height/4)
//  
//  
//  Spacer()
//  
//  
//  //          if viewStore.editOptValue == .brightness{
//  //            Slider(value: viewStore.$brightnessV) {
//  //              Text("hello")
//  //            }
//  //          }
//  
//  
//  
//  HStack(spacing: 30){
//    ForEach(editOpt.allCases, id: \.self) { item in
//      
//      switch item{
//        
//      case .brightness:
//        Button {
//          viewStore.send(.fontStyleButtonTapped)
//          //  viewStore.send(.editOptButtonTapped(.brightness))
//        } label: {
//          VStack{
//            Image(systemName: "camera")
//            Text("Style")
//          }
//        }
//        
//        
//      case .exposure:
//        Button {
//          viewStore.send(.fontStyleButtonTapped)
//        } label: {
//          VStack{
//            Image(systemName: "camera")
//            Text("Size")
//          }
//        }
//        
//      case .contrast:
//        Button {
//          viewStore.send(.fontStyleButtonTapped)
//        } label: {
//          VStack{
//            Image(systemName: "camera")
//            Text("Color")
//          }
//        }
//        
//        
//      case .saturation:
//        Button {
//          viewStore.send(.fontStyleButtonTapped)
//        } label: {
//          VStack{
//            Image(systemName: "camera")
//            Text("Grain")
//          }
//        }
//        //              case .none:
//        //                  print("hello")
//        
//      }
//      
//    }
//  }
//}
