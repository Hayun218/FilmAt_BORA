//
//  MainViewFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/16.
//

import SwiftUI

import ComposableArchitecture

struct MainViewFeature: Reducer{
  
  let filterList = FilterList()
  
  struct State: Equatable {
    
    // MARK: - Others
    var seletedPicker: tapInfo = .movie
    @BindingState var showStoreAlert: Bool = false
    
    var isOriginalImg: Bool = false
    @BindingState var isCropEnabled: Bool = false
    var originalData: Data
    var displayedUIImage: UIImage
    
    var originalCropData: Data? = nil
    var editedData: Data? = nil
    
    var cropView = CropViewFeature.State()
    var movieFilm = MovieFilmFeature.State()
    var editFilm = EditFilmFeature.State()
    
    enum tapInfo: String, CaseIterable{
      case movie = "movie mood"
      case edit = "edit"
    }
    
  }
  
  enum Action: BindableAction{
    case saveImgButtonTapped(UIImage)
    
    case showOriginalImgButtonTapped
    case cropEnabledButtonTapped
    
    case initCropImg(Data)
    case editButtonReset
    
    
    case tapEditTapped
    case tapMovieTapped
    
    case cropView(CropViewFeature.Action)
    case movieFilm(MovieFilmFeature.Action)
    case editFilm(EditFilmFeature.Action)
    
    case binding(BindingAction<State>)
  }
  
  
  var body: some ReducerOf<Self>{
    BindingReducer()
    let filterList = FilterList()
    
    Scope(state: \.movieFilm, action: /Action.movieFilm) {
      MovieFilmFeature()._printChanges()
    }
    Scope(state: \.editFilm, action: /Action.editFilm) {
      EditFilmFeature()
    }
    
    Scope(state: \.cropView, action: /Action.cropView) {
      CropViewFeature()
    }
    
    Reduce { state, action in
      
      switch action{
        
      case let .initCropImg(cropData):
        state.originalCropData = cropData
        state.editedData = state.originalCropData
        state.displayedUIImage = UIImage(data:state.originalCropData!)!
        return .none
        
      case .editButtonReset:
        state.editFilm.editButton = nil
        return .none
        
      case .showOriginalImgButtonTapped:
        state.isOriginalImg.toggle()
        if state.isOriginalImg == true{
          state.displayedUIImage = UIImage(data: state.originalCropData!)!
        } else{
          state.displayedUIImage = UIImage(data: state.editedData!)!
        }
        return .none
        
      case .cropEnabledButtonTapped:
        if state.isCropEnabled == true{
          state.cropView.lastStoredOffset = state.cropView.offset
        }
        state.isCropEnabled.toggle()
        return .none
        
      case let .saveImgButtonTapped(image):
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        state.showStoreAlert = true
        return .none
        
      case .cropView:
        return .none
        
        // MARK: - EditFilm Action
      case let .editFilm(.delegate(action)):
        switch action{
          
        case .applySharpened:
          state.displayedUIImage = UIImage(data: filterList.applySharpenFilter(imgData: state.editedData!, intensity: state.editFilm.sharpenV))!
          return .none
          
          
        }
        
        
        // MARK: - Movie Film
//      case let .movieFilm(.delegate(action)):
//        switch action{
//
//          
//          
//        case let .applyFilterOnImg(filterNum):
//          
//         // state.editedData = filterList.applyMovieFilter(imgData: state.originalCropData!, styleNum: filterNum)
//          // state.displayedUIImage = UIImage(data: state.editedData!)!
//          return .none
//          
//        }
        
        
        
        
      case .movieFilm:
        return .none
        
      case .editFilm:
        return .none
        
      case .tapEditTapped:
        state.seletedPicker = .edit
        return .none
        
      case .tapMovieTapped:
        
        
        state.seletedPicker = .movie
        return .none
        
        
      case .binding:
        return .none
        
        
      }
      
    }
    
    
  }
}

