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
  @State private var isSelected: Bool = false
  
  let opaV = 0.2
  let cornerV: CGFloat = 20
  
  public init(store: StoreOf<FilmViewFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }
  
  @State private var selectedPhoto: [PhotosPickerItem] = []
  
  var body: some View{
    NavigationStackStore(
      self.store.scope(state: \.path, action: {.path($0)})){
        
        ZStack{
          
          ScrollView(.vertical){
            LazyHStack(spacing: 0){
            //  ForEach(bgImages)
            }
          }
          
          Image("BosQue")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
           
          
          VStack{
           
            
            
              
              
              HStack (spacing: 20){
                
                
                Button {
                  viewStore.send(.camButtonTapped)
                } label: {
                  Image(systemName: "camera.fill")
                    .font(.system(size: 22))
                    
                }
                Spacer()
                
                
                if let data = viewStore.image {
                  NavigationLink(state: MainViewFeature.State(imageWithFilter: data, oriImage: data, editedImage: UIImage(data: data)!)){
                    Text("MOVIE ON THE IMAGE")
                      .foregroundColor(.white)
                  }
                  Spacer()
                }

                PhotosPicker(
                  selection: $selectedPhoto,
                  maxSelectionCount: 1,
                  matching: .any(of: [.images, .screenshots, .livePhotos])
                ) {
                  
                  Image(systemName: "photo.fill")
                    .font(.system(size: 22))
       
                }
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
                
                
              }
              .padding([.leading, .trailing, .bottom], 20)
              .background(.black.opacity(opaV))
              //.roundedCorner(20, corners: [.bottomLeft, .bottomRight])
              .foregroundColor(.white)
            
        
             
            Spacer()
            
            HStack{
              Spacer()
              VStack{
                Button {
                  
                } label: {
                  Image(systemName: "chevron.up")
                    .foregroundColor(.white)
                }
                .padding()
                
                Text("1/20")
                  .foregroundColor(.white)
                
                
                Button {
                  
                } label: {
                  Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                }
                .padding()
                
              }
//              .background(.white.opacity(opaV))
//              .cornerRadius(cornerV)
              
              
            }
            .padding()
          }
          
        }
        .fullScreenCover(isPresented: viewStore.$showCamSheet, content: {
          ImagePicker(sourceType: .camera, selectedImage: viewStore.$uiImg, isSelected: $isSelected)
        })
        .onChange(of: isSelected) { newValue in
          DispatchQueue.main.async{
            viewStore.send(.photoStored(image: viewStore.uiImg.pngData()!))
          }
          isSelected = false
        }
      }
  destination: {store  in
    MainView(store: store)
  }
  }
}
