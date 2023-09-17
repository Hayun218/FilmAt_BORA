//
//  FilmFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/16.
//


import SwiftUI
import PhotosUI

import ComposableArchitecture


struct FilmViewFeature: Reducer{
  
  struct State: Equatable{
    var image: Data?
    var path = StackState<MainViewFeature.State>()
  }
  
  enum Action{
    case photoStored(image: Data)
    case bgmImgIsTapped
    case path(StackAction<MainViewFeature.State, MainViewFeature.Action>)
  }
  
  var body: some ReducerOf<Self>{
    Reduce{ state, action in
      switch action{
        
      case let .photoStored(data):
        state.image = nil
        state.image = data
        return .none
        
      case .bgmImgIsTapped:
        return .none
        
      case .path:
        return .none
        
      }
    }
    .forEach(\.path, action: /Action.path) {
      MainViewFeature()
    }
  }
}
