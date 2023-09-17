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
    
    var image: Data
    var editedImage: UIImage
    
    var movieFilm = MovieFilmFeature.State()
    
    var seletedPicker: tapInfo = .movie
    
    enum tapInfo: String, CaseIterable{
      case movie = "movie"
      case edit = "edit"
    }
  }
  
  enum Action{
    //    case movieFilmOn
    //    case editFilmOn
    
    case tapEditTapped
    case tapMovieTapped
    case saveImgButtonTapped
    
    case movieFilm(MovieFilmFeature.Action)
  }
  
  
  var body: some ReducerOf<Self>{
    
    Scope(state: \.movieFilm, action: /Action.movieFilm) {
      MovieFilmFeature()
    }
    
    
    Reduce { state, action in
      switch action{
        
        
      case let .movieFilm(.delegate(action)):
        switch action{
        case .applyTextOnImg:
          if  state.movieFilm.isEdited {
            state.editedImage = UIImage(data: state.image)!
          }
          let uiImg = state.editedImage
          
          let composition = UIGraphicsImageRenderer(size: uiImg.size)
          
          state.editedImage = composition.image { _ in
            uiImg.draw(in: CGRect(origin: .zero, size: uiImg.size))
            
            let textAttributes: [NSAttributedString.Key: Any] = [
              .font: UIFont(name: state.movieFilm.selectedFont, size: 200) ?? UIFont.systemFont(ofSize: 200),
              .foregroundColor: UIColor.white
            ]
            
            let textSize = state.movieFilm.textOnImg.size(withAttributes: textAttributes)
            let textOrigin = CGPoint(x: (uiImg.size.width - textSize.width) / 2, y: uiImg.size.height - textSize.height - 40)
            
            
            state.movieFilm.textOnImg.draw(at: textOrigin, withAttributes: textAttributes)
            state.movieFilm.isEdited = true
          }
          
          return .none
        }
        
        
      case .movieFilm:
        return .none
        
      case .tapEditTapped:
        state.seletedPicker = .edit
        return .none
        
      case .tapMovieTapped:
        state.seletedPicker = .movie
        return .none
        
      case .saveImgButtonTapped:
        UIImageWriteToSavedPhotosAlbum(state.editedImage, nil, nil, nil)
        return .none
        
        
      }
      
    }
    
  }
}

