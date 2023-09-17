//
//  C_PurpleFilmApp.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/11.
//

import SwiftUI

import ComposableArchitecture

@main
struct C_PurpleFilmApp: App {
  static let store = Store(initialState: FilmViewFeature.State()){
    FilmViewFeature()
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      FilmView(store: C_PurpleFilmApp.store)
    }
  }
}
