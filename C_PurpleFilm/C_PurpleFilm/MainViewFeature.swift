//
//  MainViewFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/16.
//

import SwiftUI

import ComposableArchitecture

struct MainViewFeature: Reducer{
  
  struct State: Equatable {
    
    var onlyShowImage: Bool = false
    
    var imageWithFilter: Data
    var oriImage: Data
    var editedImage: UIImage
    var filteringData: Data? = nil
    
    var movieFilm = MovieFilmFeature.State()
    var editFilm = EditFilmFeature.State()
    
    var seletedPicker: tapInfo = .movie
    @BindingState var showStoreAlert: Bool = false
    
    enum tapInfo: String, CaseIterable{
      case movie = "movie mood"
      case edit = "edit"
    }
  }
  
  enum Action: BindableAction{
    
    case showOnlyImageButtonTapped
    
    case binding(BindingAction<State>)
    case tapEditTapped
    case tapMovieTapped
    case saveImgButtonTapped
    case bringTextBackOnImg
    
    case movieFilm(MovieFilmFeature.Action)
    case editFilm(EditFilmFeature.Action)
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
    
    Reduce { state, action in
      switch action{
        
      case .showOnlyImageButtonTapped:
        state.onlyShowImage.toggle()
        return .none
        
      case .binding:
        return .none
        
        // MARK: - EditFilm Action
      case let .editFilm(.delegate(action)):
        switch action{
        case let .applyFilteredImg(kind):
          let filterList = FilterList()
          var applyValue: Float = 0.0
          
          switch kind{
          case .brightness:
            applyValue = state.editFilm.brightnessV
          case .contrast:
            applyValue = state.editFilm.contrastV+1
          case .saturation:
            applyValue = state.editFilm.saturationV+1
          case .sharpen:
            applyValue = state.editFilm.sharpenV
          }
          
          state.filteringData = filterList.applyEditFilter(imgData: state.imageWithFilter, intensity: applyValue, kinds: kind)
          
          state.editFilm.isFiltering = true
          
          return .none
//          return .run{send in
//            async send(.editFilm(.delegate(.adaptFilteredImg(kind))))}
          
          
        case let .adaptFilteredImg(kind):
          
          
          // back to default
          switch kind{
          case .brightness:
            state.editFilm.contrastV = 0.0
            state.editFilm.sharpenV = 0.5
            state.editFilm.saturationV = 0.0
          case .contrast:
            state.editFilm.brightnessV = 0.0
            state.editFilm.sharpenV = 0.5
            state.editFilm.saturationV = 0.0
          case .saturation:
            state.editFilm.contrastV = 0.0
            state.editFilm.sharpenV = 0.5
            state.editFilm.brightnessV = 0.0
          case .sharpen:
            state.editFilm.contrastV = 0.0
            state.editFilm.brightnessV = 0.0
            state.editFilm.saturationV = 0.0
          }
          
          if state.filteringData == nil{
            state.filteringData = state.imageWithFilter
          }
          state.editFilm.isFiltering = false
          state.editFilm.isFiltered = true
          
          if let filteredData = state.filteringData{
            state.imageWithFilter = filteredData
          }
          
          if !state.movieFilm.isTextOn {
            if let filteredData = state.filteringData{
              print("hello")
              state.editedImage = UIImage(data: filteredData)!
            }
          } else{
            return .run {send in
              await send(.bringTextBackOnImg)
            }
          }
          return .none
        }
      case .bringTextBackOnImg:
        if state.movieFilm.isTextOn{
          state.editedImage = UIImage(data: state.imageWithFilter)!
        }
        let uiImg = state.editedImage
        
        let composition = UIGraphicsImageRenderer(size: uiImg.size)
        
        state.editedImage = composition.image { _ in
          uiImg.draw(in: CGRect(origin: .zero, size: uiImg.size))
          
          let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: state.movieFilm.selectedFont.rawValue, size: state.movieFilm.fontSize.rawValue) ?? UIFont.systemFont(ofSize: 200),
            .foregroundColor: UIColor(rgb: state.movieFilm.fontColor.rawValue)
          ]
          
          let textOnImg: String = state.movieFilm.oriTextOnImg
          
          if textOnImg != ""{
            let textSize = textOnImg.size(withAttributes: textAttributes)
            let textOrigin = CGPoint(x: (uiImg.size.width - textSize.width) / 2, y: uiImg.size.height - textSize.height - 40)
            
            
            textOnImg.draw(at: textOrigin, withAttributes: textAttributes)
            state.movieFilm.oriTextOnImg = textOnImg
            state.movieFilm.isTextOn = true
          } else{
            state.movieFilm.isTextOn = false
          }
        }
        return .none
        
        
      // MARK: - Movie Film
      case let .movieFilm(.delegate(action)):
        switch action{
        case let .applyFilterOnImg(filterNum):
          
            state.imageWithFilter = filterList.applyMovieFilter(imgData: state.oriImage, styleNum: filterNum)
            state.editedImage = UIImage(data: state.imageWithFilter)!
          
          if state.movieFilm.isTextOn {
            return .run{send in
              await send(.bringTextBackOnImg)
            }
          }
          else {return .none}
          
        case .applyTextOnImg:
          
          if state.movieFilm.isTextOn{
            state.editedImage = UIImage(data: state.imageWithFilter)!
          }
          let uiImg = state.editedImage
          
          let composition = UIGraphicsImageRenderer(size: uiImg.size)
          
          state.editedImage = composition.image { _ in
            uiImg.draw(in: CGRect(origin: .zero, size: uiImg.size))
            
            let textAttributes: [NSAttributedString.Key: Any] = [
              .font: UIFont(name: state.movieFilm.selectedFont.rawValue, size: state.movieFilm.fontSize.rawValue) ?? UIFont.systemFont(ofSize: 200),
              .foregroundColor: UIColor(rgb: state.movieFilm.fontColor.rawValue)
            ]
            let textOnImg: String = state.movieFilm.textOnImg
            
           
            if textOnImg != ""{
              let textSize = textOnImg.size(withAttributes: textAttributes)
              let textOrigin = CGPoint(x: (uiImg.size.width - textSize.width) / 2, y: uiImg.size.height - textSize.height - 40)
              
              
              textOnImg.draw(at: textOrigin, withAttributes: textAttributes)
              state.movieFilm.oriTextOnImg = textOnImg
              state.movieFilm.isTextOn = true
            } else{
              state.movieFilm.isTextOn = false
            }
          }
          return .none
        }
        
        
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
        
      case .saveImgButtonTapped:
        UIImageWriteToSavedPhotosAlbum(state.editedImage, nil, nil, nil)
        state.showStoreAlert = true
        return .none
      }
      
    }
    
  }
}

