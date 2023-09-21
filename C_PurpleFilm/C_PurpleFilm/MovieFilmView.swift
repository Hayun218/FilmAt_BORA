//
//  MovieFilmView.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/17.
//d

import SwiftUI

import ComposableArchitecture


enum movieOpt: String, CaseIterable{
  case fontStyle = "fontStyle"
  case textSize = "textSize"
  case textColor = "textColor"
  case grain = "grain"
}

enum filterStyle: Int{
  case filterOne = 0
  case filterTwo = 1
  case filterThree = 2
  case filterFour = 3
  case filterFive = 4
}

struct MovieFilmView: View, KeyboardReadable{
  let store: StoreOf<MovieFilmFeature>
  
  let buttonSize: CGFloat = 60
  
  let screenW = UIScreen.main.bounds.width
  let screenH = UIScreen.main.bounds.height
  
  @ObservedObject var viewStore: ViewStoreOf<MovieFilmFeature>
  
  public init(store: StoreOf<MovieFilmFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
    
  
    
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font names: \(names)")
    }
  }
  
  
  var body: some View{
    
    VStack{
      
      
      if !viewStore.isKeyboardVisible {
        
        
        
        // MARK: - Filter Options
        HStack(spacing: 15){
          Button {
//            DispatchQueue.global(qos: .userInteractive).async{
              viewStore.send(.filterApplyButtonTapped(.filterOne))
//            }
          } label: {
            
            Text("LAVENDAR")
              .font(.system(size: 12, weight: viewStore.selectedFilterNum == 0 ? .bold : .regular))
              .foregroundColor(Color(hex: viewStore.selectedFilterNum == 0 ? 0xB367FF : 0x747474))
              .padding(.all, 5)
              .background(viewStore.selectedFilterNum == 0 ? Color(hex: 0xD9C2F0): .clear)
              .cornerRadius(5)
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterTwo))
            
          } label: {
            Text("LILAC")
              .font(.system(size: 12, weight: viewStore.selectedFilterNum == 1 ? .bold : .regular))
              .foregroundColor(Color(hex: viewStore.selectedFilterNum == 1 ? 0xB367FF : 0x747474))
              .padding(.all, 5)
              .background(viewStore.selectedFilterNum == 1 ? Color(hex: 0xD9C2F0): .clear)
              .cornerRadius(5)
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterThree))
            
          } label: {
            Text("PLUM")
              .font(.system(size: 12, weight: viewStore.selectedFilterNum == 2 ? .bold : .regular))
              .foregroundColor(Color(hex: viewStore.selectedFilterNum == 2 ? 0xB367FF : 0x747474))
              .padding(.all, 5)
              .background(viewStore.selectedFilterNum == 2 ? Color(hex: 0xD9C2F0): .clear)
              .cornerRadius(5)
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterFour))
            
          } label: {
            Text("VIOLET")
              .font(.system(size: 12, weight: viewStore.selectedFilterNum == 3 ? .bold : .regular))
              .foregroundColor(Color(hex: viewStore.selectedFilterNum == 3 ? 0xB367FF : 0x747474))
              .padding(.all, 5)
              .background(viewStore.selectedFilterNum == 3 ? Color(hex: 0xD9C2F0): .clear)
              .cornerRadius(5)
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterFive))
            
          } label: {
            Text("MOUVE")
              .font(.system(size: 12, weight: viewStore.selectedFilterNum == 4 ? .bold : .regular))
              .foregroundColor(Color(hex: viewStore.selectedFilterNum == 4 ? 0xB367FF : 0x747474))
              .padding(.all, 5)
              .background(viewStore.selectedFilterNum == 4 ? Color(hex: 0xD9C2F0): .clear)
              .cornerRadius(5)
          }
          
        }
        .padding([.leading, .trailing], 20)
        .offset(x: 0, y: -UIScreen.screenHeight/3)
      }
      
      
      // MARK: -TextField
      
      HStack{
        TextField("영화 문구를 작성하세요.", text: viewStore.$textOnImg)
        Button {
          viewStore.send(.adaptTextButtonTapped)
        } label: {
          Text("적용하기")
        }
      }
      .padding()
      .offset(x: 0, y:  viewStore.isKeyboardVisible ? 100:0)
      
      
      
      // MARK: -MovieOpt
      
      Spacer()
      
      if !viewStore.isKeyboardVisible {
        
        HStack(spacing: 29){
          ForEach(movieOpt.allCases, id: \.self) { item in
            
            switch item{
              
            case .fontStyle:
              Button {
                viewStore.send(.fontStyleButtonTapped)
              } label: {
                  VStack{
                    Image(systemName: "textformat")
                      .frame(width: buttonSize, height: buttonSize)
                      .background(Color(hex: 0xD9D9D9))
                      .clipShape(
                        Circle())
                      .overlay(
                        RoundedRectangle(cornerRadius: 100)
                        .inset(by: 4)
                        .trim(from: 0, to: CGFloat(0.35))
                        .stroke(Color(hex: 0xDEC1FB), lineWidth: 5)
                        .rotationEffect(.degrees(Double(viewStore.fontStyleIndex)*10))
                      )
                    Text("FONT")
                      .font(.system(size: 10))
                      .foregroundColor(Color(hex: 0x747474))
                  }
                  .foregroundColor(.black)
              }
              
              
            case .textSize:
              Button {
                viewStore.send(.fontSizeButtonTapped)
                
                
              } label: {
                VStack{
                  Image(systemName: "textformat.size")
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(Circle())
                  .overlay(
                    RoundedRectangle(cornerRadius: 100)
                    .inset(by: 4)
                    .trim(from: 0, to: CGFloat(0.35))
                    .stroke(Color(hex: 0xDEC1FB), lineWidth: 5)
                    .rotationEffect(.degrees(Double(viewStore.fontSizeIndex)*10))
                  )
                   
                  Text("SIZE")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: 0x747474))
                }
                .foregroundColor(.black)
                }
              
              
            case .textColor:
              Button {
                viewStore.send(.fontColorButtonTapped)
              } label: {
                VStack{
                  Image(systemName: "circle.fill")
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(Circle())
                    .overlay(
                      RoundedRectangle(cornerRadius: 100)
                      .inset(by: 4)
                      .trim(from: 0, to: CGFloat(0.35))
                      .stroke(Color(hex: 0xDEC1FB), lineWidth: 5)
                      .rotationEffect(.degrees(Double(viewStore.fontColorIndex)*10))
                    )
                   
                  Text("COLOR")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: 0x747474))
                }
                .foregroundColor(.black)
              }
              
              
            case .grain:
              Button {
                viewStore.send(.fontStyleButtonTapped)
              } label: {
                VStack{
                  Image("grainIcon")
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(Circle())
                   
                  Text("GRAIN")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: 0x747474))
                }
                .foregroundColor(.black)
              }
              
            }
            
          }
        }
        .padding([.leading, .trailing], 24)
        .padding(.bottom, 37)
        
        
        
      }
    }
    .onReceive(keyboardPublisher) { newIsKeyboardVisible in
      print("Is keyboard visible? ", newIsKeyboardVisible)
      viewStore.send(.isKeyBoardAppeared(newIsKeyboardVisible))
    }
  }
}
