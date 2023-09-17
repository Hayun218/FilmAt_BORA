//
//  MovieFilmView.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/17.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

import ComposableArchitecture


enum movieOpt: String, CaseIterable{
  case textSize = "textSize"
  case textColor = "textColor"
  case fontStyle = "fontStyle"
  case grain = "grain"
}


struct MovieFilmView: View{
  let store: StoreOf<MovieFilmFeature>
  
  let screenW = UIScreen.main.bounds.width
  let screenH = UIScreen.main.bounds.height
  
  @ObservedObject var viewStore: ViewStoreOf<MovieFilmFeature>
  
  public init(store: StoreOf<MovieFilmFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }
  
  
  @Namespace var animation
  
  var body: some View{
    
    
    
    VStack{
      
      
      // MARK: -SizeRatio Buttons
      HStack{
        Button {
          viewStore.send(.size16ButtonTapped)
        } label: {
          Text("16/9")
            .frame(width: 26*4, height: 9*4)
            .background(Color("AccentColor").opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(6)
        }
      
        
        
        Button {
          viewStore.send(.size21ButtonTapped)
        } label: {
          Text("21/9")
            .frame(width: 21*4, height: 9*4)
            .background(Color("AccentColor").opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(6)
          
        }
      }
      .frame(width: screenW, height:screenH/10)
      .padding()
      .offset(x: 0, y: -screenH/2.3)
      
      
      // MARK: - Film
      Button {
        viewStore.send(.filterApplyButtonTapped)
        
      } label: {
        Text("Filter")
      } .offset(x: 0, y: -screenH/2.2)
      
      
      // MARK: -TextField
      
      
      HStack{
        TextField("영화 문구를 작성하세요.", text: viewStore.$textOnImg)
          .padding()
        
        Button {
          viewStore.send(.adaptTextButtonTapped)
        } label: {
          Text("적용하기")
        }
      }
      .padding()
      .offset(x: 0, y: -screenH/8)
      
      
      // MARK: -MovieOpt
      
      Spacer()
      
      HStack(){
        ForEach(movieOpt.allCases, id: \.self) { item in
          
          switch item{
            
          case .fontStyle:
            Button {
              
              viewStore.send(.fontStyleButtonTapped)
            } label: {
              VStack{
                Image(systemName: "camera")
                Text("Style")
              }
            }
            
            
          case .textSize:
            Button {
              viewStore.send(.fontStyleButtonTapped)
            } label: {
              VStack{
                Image(systemName: "camera")
                Text("Size")
              }
            }
            
          case .textColor:
            Button {
              viewStore.send(.fontStyleButtonTapped)
            } label: {
              VStack{
                Image(systemName: "camera")
                Text("Color")
              }
            }
            
            
          case .grain:
            Button {
              viewStore.send(.fontStyleButtonTapped)
            } label: {
              VStack{
                Image(systemName: "camera")
                Text("Grain")
              }
            }
            
          }
          
        }.padding()
        
      }
    }
  }
}
