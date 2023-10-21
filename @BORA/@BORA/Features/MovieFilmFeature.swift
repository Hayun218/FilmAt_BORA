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
    var isFirst: Bool = true
    
    var selectedFilter = "none"
    var currentFilter = "none"
    
    var isKeyboardVisible = false
    var fontTypeIndex: Int = 0
    var selectedFont: fontStyle = .thousnd
    var fontSizeIndex: Int = 0
    var fontSize: fontSize = .small
    var fontStyleIndex: Int = 0
    var fontType: fontType = .plain
    var grainStyleIndex = 0
    var grainStyle: grainStyle = .one
    
    
    @BindingState var grainV: Float = 0.0
    
    
    @BindingState var textOnImg: String = ""
    var oriTextOnImg: String = ""
    
    var isTexting: Bool = false
    
    enum fontType: Int {
      case plain = 1
      case opacity = 2
      case stroke = 3
    }
    
    enum fontSize: CGFloat {
      case small = 16
      case medium = 19
      case large = 21
    }
    
    enum fontStyle: String, CaseIterable {
      //      case chosun = "ChosunilboNM"
      //      case hakgo = "HakgyoansimWoojuR"
      //      case nanum = "NanumGothic"
      //      case nexon_bold = "NanumGothicd"
      
      case thousnd = "GyeonggiBatangROTF"
      case thousnd_bold = "GyeonggiBatangROTB"
      case nanum = "NanumGothicOTF"
      case nanum_bold = "NanumGothicOTFBold"
      case nexon = "WarhavenOTFR"
      case nexon_bold = "WarhavenOTFB"
      case suite = "SUITE-Regular"
      case suite_bold = "SUITE-Bold"
    }
    
    enum grainStyle: String {
      case one = "grain0"
      case two = "grain1"
      case three = "grain2"
    }
    
    
    
  }
  
  enum Action: BindableAction{
    
    case checkFirst
    
    case textAddButtonTapped
    case isKeyBoardAppeared(Bool)
    case fontStyleButtonTapped
    case fontSizeButtonTapped
    case styleButtonTapped
    case grainButtonTapped
    //    case grainSliderMoved
    
    case filterApplyButtonTapped(filterStyle)
    
    case binding(BindingAction<State>)
  }
  
  
  var body: some ReducerOf<Self>{
    BindingReducer()
    
    Reduce { state, action in
      switch action{
        
      case .checkFirst:
        if UserDefaults.standard.object(forKey: "isFirst") == nil {
          UserDefaults.standard.set(true, forKey: "isFirst")
          state.isFirst = true
        } else {
          state.isFirst = UserDefaults.standard.bool(forKey: "isFirst")
        }
        return .none
        
      case .textAddButtonTapped:
        state.isTexting.toggle()
        return .none
        
      case let .isKeyBoardAppeared(newKeyValue):
        state.isKeyboardVisible = newKeyValue
        return .none
        
      case .fontStyleButtonTapped:
        if state.fontTypeIndex+12 > 25 {
          state.fontTypeIndex = 0
        } else {
          state.fontTypeIndex += 12 }
        
        if state.fontTypeIndex == 0 {
          state.selectedFont = .thousnd
        } else if state.fontTypeIndex == 12 {
          state.selectedFont = .nanum
        } else {
          state.selectedFont = .suite
        }
        return .none
        
      case .styleButtonTapped:
        if state.fontStyleIndex+12 > 25 {
          state.fontStyleIndex = 0
        } else {
          state.fontStyleIndex += 12 }
        
        if state.fontStyleIndex == 0 {
          state.fontType = .plain
        } else if state.fontStyleIndex == 12 {
          state.fontType = .opacity
          
//          if state.selectedFont == .suite {
//            state.selectedFont = .suite_bold
//          }
//          if state.selectedFont == .nanum {
//            state.selectedFont = .nanum_bold
//          }
//          if state.selectedFont == .thousnd {
//            state.selectedFont = .thousnd_bold
//          }
        } else {
          state.fontType = .stroke
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
