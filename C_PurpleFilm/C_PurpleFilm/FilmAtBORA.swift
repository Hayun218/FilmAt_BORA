//
//  C_PurpleFilmApp.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/11.
//

import SwiftUI

import ComposableArchitecture

@available(iOS 17.0, *)
@main
struct FilmAtBORA: App {
  static let store = Store(initialState: FilmViewFeature.State()){
    FilmViewFeature()
     // ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      FilmView(store: FilmAtBORA.store)
    }
  }
}
