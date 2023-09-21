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
    @BindingState var sharpenV: Float = 0.5
    @BindingState var saturationV: Float = 0.0
    
    var isFiltered: Bool = false
    var isFiltering: Bool = false
  }
  
  enum Action:  BindableAction{
    
    case binding(BindingAction<State>)
    case editOptButtonTapped(editOpt)
    
    case delegate(Delegate)
    
    case applyButtonTapped(editOpt)
    
    case applySliders(editOpt)
    enum Delegate{
      case applyFilteredImg(editOpt)
      case adaptFilteredImg(editOpt)
      
    }
    
  }
  
  var body: some ReducerOf<Self>{
    BindingReducer()
    
    Reduce { state, action in
      switch action{
        
      case let .applySliders(kind):
        return .run {send in
          await send(.delegate(.applyFilteredImg(kind)))
        }
        
      case let .applyButtonTapped(kind):
        return .run {send in
          await send(.delegate(.adaptFilteredImg(kind)))
        }
        
      case let .editOptButtonTapped(editOptValue):
        if state.editButton == editOptValue{
          state.editButton = .none
          state.isFiltering = false
        }else{
          state.isFiltering = false
          state.editButton = editOptValue}
        // back to default
        switch editOptValue{
        case .brightness:
          state.contrastV = 0.0
          state.sharpenV = 0.5
          state.saturationV = 0.0
        case .contrast:
          state.brightnessV = 0.0
          state.sharpenV = 0.5
          state.saturationV = 0.0
        case .saturation:
          state.contrastV = 0.0
          state.sharpenV = 0.5
          state.brightnessV = 0.0
        case .sharpen:
          state.contrastV = 0.0
          state.brightnessV = 0.0
          state.saturationV = 0.0
        }
        return .none
        
      
      case .binding:
        return .none
        
        
      case .delegate:
        return .none
        
      }
    }
  }
}
