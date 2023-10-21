//
//  CropViewFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 10/9/23.
//

import SwiftUI

import ComposableArchitecture

struct CropViewFeature: Reducer{
  
  struct State: Equatable{
    
    
    //MARK: - Crop Properties
    var offset: CGSize = .zero
    var lastStoredOffset: CGSize = .zero
    
    var scale: CGFloat = 1
    var lastScale: CGFloat = 0
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle){
      UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
  }
  
  enum Action: Equatable{
    case offsetChanged(CGSize)
    case scaleChanged(CGFloat)
    case scaleAdjust
    case keepInBorder(CGRect)
    case saveOffset
  }
  
  var body: some ReducerOf<Self>{
    
    Reduce{ state, action in
      switch action{
        
        
      case let .offsetChanged(translation):
        state.offset = CGSize(width: translation.width + state.lastStoredOffset.width, height: translation.height+state.lastStoredOffset.height)
        return .none
        
      case .saveOffset:
        state.lastStoredOffset = state.offset
        return .none
        
      case let .scaleChanged(value):
        let updatedS = value + state.lastScale
        state.scale = (updatedS < 1 ? 1: updatedS)
        return .none
        
      case .scaleAdjust:
        if state.scale < 1 {
          state.scale = 1
          state.lastScale = 0
        }else{
          state.lastScale = state.scale - 1
        }
        return .none
        
      case let .keepInBorder(rect):
        withAnimation {
          
          if rect.minX > 0 {
            state.offset.width = (state.offset.width - rect.minX)
            state.haptics(.medium)
          }
          
          if rect.maxX < rect.width {
            state.offset.width = (rect.minX - state.offset.width)
            state.haptics(.medium)
          }
          // TODO: *9/16 비율에 맞추어 Y 조절하기
//          if rect.minY < 0 {
//
//            state.offset.height = state.offset.height - rect.minY
//            state.haptics(.medium)
//          }
          //          if rect.maxY > rect.height{
          //
          //            state.offset.height = rect.maxY //(rect.maxY - state.offset.height)
          //            state.haptics(.medium)
          //          }
        }
        return .none
        
        
        
      }
    }
  }
}
