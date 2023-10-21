//
//  MainViewFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/16.
//

import SwiftUI

import ComposableArchitecture

struct MainViewFeature: Reducer {
  
  let filterList = FilterList()
  
  struct State: Equatable {
    var isFirst: Bool = true
    
    @BindingState var showStoreAlert: Bool = false
    @BindingState var isReturned: Bool = false
    @BindingState var isCropEnabled: Bool = false
    
    var seletedPicker: tapInfo = .movie
    var isOriginalImg: Bool = false
    var originalData: Data
    var displayedUIImage: UIImage
    
    var originalCropData: Data? = nil
    
    var cropView = CropViewFeature.State()
    var movieFilm = MovieFilmFeature.State()
    var editFilm = EditFilmFeature.State()
    
    enum tapInfo: String, CaseIterable {
      case movie = "movie mood"
      case edit = "edit"
    }
  }
  
  enum Action: BindableAction {
    
    case checkFirst
    
    case initCropImg(Data)
    case returnToMainButtonTapped
    case saveImgButtonTapped(UIImage)
    
    case tapMovieTapped
    case tapEditTapped
    case editButtonReset
    
    case showOriginalImgButtonTapped
    case cropEnabledButtonTapped
    
    case cropView(CropViewFeature.Action)
    case movieFilm(MovieFilmFeature.Action)
    case editFilm(EditFilmFeature.Action)
    
    case binding(BindingAction<State>)
  }
  
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    let filterList = FilterList()
    
    Scope(state: \.movieFilm, action: /Action.movieFilm) {
      MovieFilmFeature()
    }
    Scope(state: \.editFilm, action: /Action.editFilm) {
      EditFilmFeature()
    }
    
    Scope(state: \.cropView, action: /Action.cropView) {
      CropViewFeature()
    }
    
    Reduce { state, action in
      
      switch action {
        
      case .checkFirst:
        if UserDefaults.standard.object(forKey: "isFirst") == nil {
          UserDefaults.standard.set(true, forKey: "isFirst")
          state.isFirst = true
        } else {
          state.isFirst = UserDefaults.standard.bool(forKey: "isFirst")
        }
        return .none
        
        
      case let .initCropImg(cropData):
        state.originalCropData = cropData
        state.displayedUIImage = UIImage(data:state.originalCropData!)!
        return .none
        
      case .returnToMainButtonTapped:
        state.isReturned.toggle()
        return .none
        
      case let .saveImgButtonTapped(image):
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        state.showStoreAlert = true
        return .none
        
      case .tapMovieTapped:
        state.seletedPicker = .movie
        return .none
        
      case .tapEditTapped:
        state.seletedPicker = .edit
        return .none
        
      case .editButtonReset:
        state.editFilm.editButton = nil
        return .none
        
      case .showOriginalImgButtonTapped:
        state.isOriginalImg.toggle()
        if state.editFilm.sharpenV != 0 {
          return .run{ send in
            await send(.editFilm(.applySharpend))
          }
        }
        return .none
        
      case .cropEnabledButtonTapped:
        state.isCropEnabled.toggle()
        return .none
        
      case .cropView:
        return .none
        
      case .movieFilm:
        return .none
        
        // MARK: - EditFilm Action
      case let .editFilm(.delegate(action)):
        switch action {
          
        case .applySharpened:
          state.displayedUIImage = UIImage(data: filterList.applySharpenFilter(imgData: state.originalCropData!, intensity: state.editFilm.sharpenV))!
          return .none
        }
        
      case .editFilm:
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}
