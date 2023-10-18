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
    @PresentationState var mainView: MainViewFeature.State?
    
    @BindingState var showCamSheet: Bool = false
    @BindingState var isCamPhotoOpened: Bool = false
    @BindingState var isGalleryOpened: Bool = false
    
    @BindingState var uiImg = UIImage()
  }
  
  enum Action: BindableAction{
    case mainView(PresentationAction<MainViewFeature.Action>)
    case galleryButtonTapped
    case camButtonTapped
    case photoSelectionCompleted
    case loadData(Data)
    case binding(BindingAction<State>)
  }
  
  var body: some ReducerOf<Self>{
    BindingReducer()
    
    Reduce{ state, action in
      switch action{
        
      case .mainView(_):
        return .none
        
      case .galleryButtonTapped:
        state.isGalleryOpened = true
        return .none
        
      case .camButtonTapped:
        state.showCamSheet = true
        return .none
        
      case .photoSelectionCompleted:
        state.isGalleryOpened = false
        state.isCamPhotoOpened = false
        return .none
        
      case let .loadData(data):
        state.mainView = MainViewFeature.State(originalData: data, displayedUIImage: state.uiImg)
        return .none
        
      case .binding:
        return .none
      }
    }
    .ifLet(\.$mainView, action: /Action.mainView){
      MainViewFeature()
//        ._printChanges()
    }
  }
}
