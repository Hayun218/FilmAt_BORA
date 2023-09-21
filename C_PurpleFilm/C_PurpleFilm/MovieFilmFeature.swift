//
//  MovieFilmFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/12.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

import ComposableArchitecture

struct MovieFilmFeature: Reducer{
  
  struct State: Equatable {
    
    
    var selectedFilterNum = 5
    var isKeyboardVisible = false
    var fontStyleIndex: Int = 0
    var selectedFont: fontStyle = .chosun
    
    var fontSizeIndex: Int = 0
    var fontSize: fontSize = .small
    
    var fontColorIndex: Int = 0
    var fontColor: fontColor = .black
    
    
    @BindingState var textOnImg: String = ""
    var oriTextOnImg: String = ""
    
    var isTextOn: Bool = false
    
    enum fontColor: Int {
      case black = 0x000000
      case gray = 0x808080
      case white = 0xFFFFFF
    }
   
    enum fontSize: CGFloat{
      case small = 220
      case medium = 260
      case large = 300
    }
    
    enum fontStyle: String, CaseIterable{
      case chosun = "ChosunilboNM"
      case hakgo = "HakgyoansimWoojuR"
      case nanum = "NanumGothic"
    }
    
  }
  
  enum Action: BindableAction{
    
    case isKeyBoardAppeared(Bool)
    
    case adaptTextButtonTapped
    
    case fontStyleButtonTapped
    case fontSizeButtonTapped
    case fontColorButtonTapped
    
    case filterApplyButtonTapped(filterStyle)
    
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    enum Delegate{
      case applyTextOnImg
      case applyFilterOnImg(filterStyle)
      
    }
  }
  
  
  var body: some ReducerOf<Self>{
    BindingReducer()
    
    Reduce { state, action in
      switch action{
        
      case let .filterApplyButtonTapped(filterNum):
        state.selectedFilterNum = filterNum.rawValue
        return .run{ send in
          await send(.delegate(.applyFilterOnImg(filterNum)))
        }
        
        
      case .delegate:
        return .none
        
        
      case .fontColorButtonTapped:
        
        if state.fontColorIndex+12 > 25{
          state.fontColorIndex = 0
        }else{
          state.fontColorIndex += 12}
        
        if state.fontColorIndex == 0 {
          state.fontColor = .black
        } else if state.fontSizeIndex == 12{
          state.fontColor = .gray
        } else {
          state.fontColor = .white
        }
        
        return .run{send in
          await send(.delegate(.applyTextOnImg))
        }
        
     
        
      
      case .fontSizeButtonTapped:
        
        if state.fontSizeIndex+12 > 25{
          state.fontSizeIndex = 0
        }else{
          state.fontSizeIndex += 12}
        
        if state.fontStyleIndex == 0 {
          state.fontSize = .small
        } else if state.fontStyleIndex == 12{
          state.fontSize = .medium
        } else {
          state.fontSize = .large
        }
        return .run{send in
          await send(.delegate(.applyTextOnImg))
        }
        
      case let .isKeyBoardAppeared(newKeyValue):
        state.isKeyboardVisible = newKeyValue
        return .none
      
        
      case .fontStyleButtonTapped:
        if state.fontStyleIndex+12 > 25{
          state.fontStyleIndex = 0
        }else{
          state.fontStyleIndex += 12}
        
        if state.fontStyleIndex == 0 {
          state.selectedFont = .chosun
        } else if state.fontStyleIndex == 12{
          state.selectedFont = .hakgo
        } else {
          state.selectedFont = .nanum
        }
        
        return .run{send in
          await send(.delegate(.applyTextOnImg))
        }
        
        
      case .binding:
        return .none
        
      case .adaptTextButtonTapped:
        return .run{ send in
          await send(.delegate(.applyTextOnImg))
        }
        
        
      }
    }
  }
}
