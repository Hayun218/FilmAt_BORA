//
//  EditFilmFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/17.
//
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

import ComposableArchitecture


struct EditFilmFeature: Reducer{
  struct State: Equatable{
    var editButton: editOpt? = nil
    
    @BindingState var brightnessV: Float = 0.0
    @BindingState var contrastV: Float = 0.0
    @BindingState var sharpenV: Float = 0.0
    @BindingState var saturationV: Float = 0.0
    
    var isEditing: Bool = false
    
    mutating func initValues(){
      self.brightnessV = 0.0
      self.contrastV = 0.0
      self.sharpenV = 0.0
      self.saturationV = 0.0
    }
  }
  
  enum Action:  BindableAction{
    
    case editOptButtonTapped(editOpt)
    case resetButtonTapped
    case applySharpend
    
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    enum Delegate{
      case applySharpened
    }
  }
  
  var body: some ReducerOf<Self>{
    BindingReducer()
    
    
    Reduce { state, action in
    
      switch action{
      
        
      case let .editOptButtonTapped(editOptValue):
        if state.editButton == editOptValue{
          state.editButton = nil
        }else{
          state.editButton = editOptValue
        }
        return .none
        
      case .resetButtonTapped:
        if state.sharpenV != 0 {
          state.initValues()
          return .run{send in
            await send(.delegate(.applySharpened))
          }
        }
        state.initValues()
        
        return .none
        
      case .applySharpend:
        return .run {send in
          await send(.delegate(.applySharpened))
        }

        
      case .binding:
        return .none
        
      case .delegate:
        return .none
        
      }
    }
  }
}
