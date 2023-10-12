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
    
    
    var selectedFilter = "none"
    var currentFilter = "none"
    
    var isKeyboardVisible = false
    var fontStyleIndex: Int = 0
    var selectedFont: fontStyle = .chosun
    var fontSizeIndex: Int = 0
    var fontSize: fontSize = .small
    var fontColorIndex: Int = 0
    var fontColor: fontColor = .black
    var grainStyleIndex = 0
    var grainStyle: grainStyle = .one
    
//    var isGrainOn: Bool = false
    
    @BindingState var grainV: Float = 0.0
    
    
    @BindingState var textOnImg: String = ""
    var oriTextOnImg: String = ""
    
    var isTexting: Bool = false
    
    enum fontColor: Int {
      case black = 0x000000
      case gray = 0x808080
      case white = 0xFFFFFF
    }
   
    enum fontSize: CGFloat{
      case small = 16
      case medium = 20
      case large = 24
    }
    
    enum fontStyle: String, CaseIterable{
      case chosun = "ChosunilboNM"
      case hakgo = "HakgyoansimWoojuR"
      case nanum = "NanumGothic"
    }
    
    enum grainStyle: String{
      case one = "grain0"
      case two = "grain1"
      case three = "grain2"
    }
    
    
    
  }
  
  enum Action: BindableAction{
    
    case textAddButtonTapped
    case isKeyBoardAppeared(Bool)
    
    case fontStyleButtonTapped
    case fontSizeButtonTapped
    case fontColorButtonTapped
    case grainButtonTapped
//    case grainSliderMoved
    
    case filterApplyButtonTapped(filterStyle)
    
    case binding(BindingAction<State>)
//    case delegate(Delegate)
    
//    enum Delegate{
//      case applyFilterOnImg(filterStyle)
//      
//    }
  }
  
  
  var body: some ReducerOf<Self>{
    BindingReducer()
    
    Reduce { state, action in
      switch action{
        
      case .textAddButtonTapped:
        state.isTexting.toggle()
        return .none
        
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
        return .none
        
      case .fontColorButtonTapped:
        
        if state.fontColorIndex+12 > 25{
          state.fontColorIndex = 0
        }else{
          state.fontColorIndex += 12}
        
        if state.fontColorIndex == 0 {
          state.fontColor = .black
        } else if state.fontColorIndex == 12{
          state.fontColor = .gray
        } else {
          state.fontColor = .white
        }
        
        return .none
      
      case .fontSizeButtonTapped:
        
        if state.fontSizeIndex+12 > 25{
          state.fontSizeIndex = 0
        }else{
          state.fontSizeIndex += 12}
        
        if state.fontSizeIndex == 0 {
          state.fontSize = .small
        } else if state.fontSizeIndex == 12{
          state.fontSize = .medium
        } else {
          state.fontSize = .large
        }
        return .none
        
        
      case .grainButtonTapped:
        if state.grainStyleIndex+12 > 25{
          state.grainStyleIndex = 0
        }else{
          state.grainStyleIndex += 12}
        
        if state.grainStyleIndex == 0 {
          state.grainStyle = .one
        } else if state.grainStyleIndex == 12{
          state.grainStyle = .two
        } else {
          state.grainStyle = .three
        }
//        state.isGrainOn.toggle()
        return .none
        
//      case .grainSliderMoved:
//        return .run {send in
//          await send(.delegate(.applyGrainOnImg))
//        }
        
        
        
        
      case let .filterApplyButtonTapped(filterType):
        state.selectedFilter = filterType.rawValue
        if state.currentFilter == state.selectedFilter{
          state.currentFilter = "none"
          state.selectedFilter = "none"
        }else{
          state.currentFilter = filterType.rawValue
        }
        return .none
        
//      case .delegate:
//        return .none
//        
      case .binding:
        return .none
        
        
      }
    }
  }
}
