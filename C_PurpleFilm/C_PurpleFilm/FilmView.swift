//
//  FilmFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/11.
//

import SwiftUI
import PhotosUI

import ComposableArchitecture


struct FilmView: View{
  
  let store: StoreOf<FilmViewFeature>
  
  @ObservedObject private var viewStore: ViewStoreOf<FilmViewFeature>
  
  public init(store: StoreOf<FilmViewFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }
  
  @State private var selectedPhoto: [PhotosPickerItem] = []
  
  
  var body: some View{
    NavigationStackStore(
      self.store.scope(state: \.path, action: {.path($0)})){

      ZStack{
        
        Image("BosQue")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(minWidth: 0, maxWidth: .infinity)
          .edgesIgnoringSafeArea(.all)
        
        
        VStack{
          Spacer()
          
          if let data = viewStore.image {
            
            NavigationLink(state: MainViewFeature.State(image: data, editedImage: UIImage(data: data)!)){
              Text("Here!! for MovieFilmView")
            }
          }
          
          
          PhotosPicker(
            selection: $selectedPhoto,
            maxSelectionCount: 1,
            matching: .any(of: [.images, .screenshots, .livePhotos])
          ) {
            
            Image(systemName: "camera")
            
            
          }
          .padding()
          .background(.white.opacity(0.5))
          .cornerRadius(30)
          .foregroundColor(.accentColor)
          
          .onChange(of: selectedPhoto) { newValue in
            guard let image = selectedPhoto.first else{
              return
            }
            image.loadTransferable(type: Data.self) { result in
              switch result{
              case .success(let data):
                if let data = data{
                  DispatchQueue.main.async{
                    viewStore.send(.photoStored(image: data))
                  }
                } else{
                  print("Data is nil")
                }
              case .failure(let failure):
                fatalError("\(failure)")
                
              }
            }
            
          }
          Spacer()
          
          
          
          Text("BosQue")
            .foregroundColor(.white)
          
          Divider()
          
        }
        
      }
    }
  destination: {store  in
    MainView(store: store)
  }
  }
}
