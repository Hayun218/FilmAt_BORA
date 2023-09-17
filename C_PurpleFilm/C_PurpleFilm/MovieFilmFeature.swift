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
    
    var isSize16 = true
    var fontStyleOpened: Bool = false
    
    //var editButton: editOpt = .brightness
//    @BindingState var brightnessV: Float = 0.0
    
    // movie text apply
    @BindingState var textOnImg: String = ""
    var isEdited: Bool = false
    var selectedFont: String = fontStyle.nanum.rawValue
    
    enum fontStyle: String{
      case chosun = "ChosunilboNM"
      case hakgo = "HakgyoansimWoojuRh"
      case nanum = "NanumGothic"
    }
  }
  
  enum Action: BindableAction{
    
    
    case size16ButtonTapped
    case size21ButtonTapped
        
    // movie Text
    case adaptTextButtonTapped
    case binding(BindingAction<State>)
    
    case fontStyleButtonTapped
    
    case filterApplyButtonTapped
    
    //case editOptButtonTapped(editOpt)
    
    
    case delegate(Delegate)
    
    enum Delegate{
      case applyTextOnImg
      
    }
    
    
    
  }
  
  
  var body: some ReducerOf<Self>{
//    let filterList = FilterList()
    BindingReducer()
    
    Reduce { state, action in
      switch action{
        
      case .filterApplyButtonTapped:
//        state.editedImage = filterList.amplifyPurpleColor(imgData: state.image)
        
        return .none
        
      case .delegate:
        return .none
        
        
      case .size16ButtonTapped:
        state.isSize16 = true
        return .none
        
      case .size21ButtonTapped:
        state.isSize16 = false
        return .none
        
//      case let .editOptButtonTapped(editOptValue):
//        state.editButton = editOptValue
//        return .none
        
      case .fontStyleButtonTapped:
        state.fontStyleOpened.toggle()
        return .none
        
        
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
