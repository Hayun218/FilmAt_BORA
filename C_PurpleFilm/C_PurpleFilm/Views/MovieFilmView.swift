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

enum filterStyle: String{
  case filterZero = "none"
  case filterOne = "Lavendar"
  case filterTwo = "Lilac"
  case filterThree = "Plum"
  case filterFour = "Violet"
  case filterFive = "Mouve"
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
    
    //    for family in UIFont.familyNames.sorted() {
    //        let names = UIFont.fontNames(forFamilyName: family)
    //        print("Family: \(family) Font names: \(names)")
    //    }
  }
  
  
  var body: some View{
    
    VStack{
      
      
      if !viewStore.isKeyboardVisible {
        
        // MARK: - Filter Options
        // TODO: - for each
        HStack(spacing: 15){
          Button {
            //            DispatchQueue.global(qos: .userInteractive).async{
            viewStore.send(.filterApplyButtonTapped(.filterOne))
            //            }
          } label: {
            FilterTextView(title: "LAVENDAR", filterType: viewStore.currentFilter, currentFilterType: "Lavendar")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterTwo))
            
          } label: {
            FilterTextView(title: "LILAC", filterType: viewStore.currentFilter, currentFilterType: "Lilac")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterThree))
            
          } label: {
            FilterTextView(title: "PLUM", filterType: viewStore.currentFilter, currentFilterType: "Plum")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterFour))
            
          } label: {
            FilterTextView(title: "VIOLET", filterType: viewStore.currentFilter, currentFilterType: "Violet")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterFive))
            
          } label: {
            FilterTextView(title: "MOUVE", filterType: viewStore.currentFilter, currentFilterType: "Mouve")
          }
          
        }
        .padding([.leading, .trailing], 20)
        .offset(x: 0, y: -UIScreen.screenHeight/2.6)
      }
      
      
      // MARK: -TextField
      
      
      HStack{
        Spacer()
        if viewStore.isTexting == true{
          withAnimation {
            TextField("영화 자막",
                      text: viewStore.$textOnImg,
                      axis: .vertical)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray200)
          }
        }
        
        Spacer()
        
        Button{
          viewStore.send(.textAddButtonTapped)
        }label:{
          Image(systemName: viewStore.isTexting ? "checkmark" :"text.badge.plus")
            .font(.system(size: 18))
        }
      }
      .foregroundColor(.black)
      .padding()
      .offset(x: 0, y:  viewStore.isKeyboardVisible ? 120:0)
    
      
      
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
                
                ButtonLabelWithOverlay(img: "textformat", text: "FONT", index: viewStore.fontStyleIndex)
              }
              
            case .textSize:
              Button {
                viewStore.send(.fontSizeButtonTapped)
              } label: {
                ButtonLabelWithOverlay(img: "textformat.size", text: "SIZE", index: viewStore.fontSizeIndex)
              }
              
            case .textColor:
              Button {
                viewStore.send(.fontColorButtonTapped)
              } label: {
                ButtonLabelWithOverlay(img: "circle.fill", text: "COLOR", index: viewStore.fontColorIndex)
              }
              
              
            case .grain:
              Button {
                viewStore.send(.grainButtonTapped)
              } label: {
                VStack{
                  Image("grainIcon")
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(Circle())
                    .overlay(
                      RoundedRectangle(cornerRadius: 100)
                        .inset(by: 4)
                        .trim(from: 0, to: CGFloat(0.35))
                        .stroke(Color(hex: 0xDEC1FB), lineWidth: 5)
                        .rotationEffect(.degrees(Double(viewStore.grainStyleIndex)*10))
                    )
                  
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
      viewStore.send(.isKeyBoardAppeared(newIsKeyboardVisible))
    }
  }
}
