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
  
  @State var isGalleryOpened:Bool = false
  
  public init(store: StoreOf<FilmViewFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }
  
  let bgI = BackImages()
  
  var body: some View{
    NavigationStack{
      VStack(spacing: 0){
        // MARK: - Tab Menu Bar
        HStack(spacing: 22){
          Image("@BORA_purple")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 30)
          Spacer()
          Button {
            viewStore.send(.camButtonTapped)
          } label: {
            Image(systemName: "camera")
          }
          Button {
            viewStore.send(.galleryButtonTapped)
          } label: {
            Image(systemName: "photo")
          }
        }
        .font(.system(size: 20))
        .padding(16)
        .background(.white)
        .foregroundColor(.black)

        
        // MARK: - ScrollView BGI
        GeometryReader { gr in
          ScrollViewReader{ value in
            ScrollView(.horizontal){
              LazyHStack(spacing: 0){
                ForEach(bgI.bgImages.indices, id: \.self){ index in
                  VStack{
                    Image(bgI.bgImages[index].name)
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: gr.size.width)
                      .id(bgI.bgImages[index].id)
                    
                    HStack{
                      VStack(alignment: .leading){
                        HStack(spacing: 3){
                          Image(systemName: "at")
                          Text(bgI.bgLocation[index])
                            .id(bgI.bgImages[index].id)
                          Spacer()
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.black)
                        
                        Text(bgI.bgTexts[index])
                          .id(bgI.bgImages[index].id)
                          .font(.system(size: 14))
                          .foregroundStyle(.gray200)
                          .padding([.top], 14)
                        
                        Spacer()
                      }
                      Spacer()
                      Button {
                        if index+1 < bgI.bgImages.count{
                          withAnimation{
                            value.scrollTo(index+1)
                          }
                        }
                      } label: {
                        Image(systemName: "chevron.right")
                      }
                      .font(.system(size: 16))
                      .foregroundStyle(.black)
                    }
                    .padding(24)
                  }
                  
                  .frame(width: gr.size.width,
                         height: gr.size.height)
                }
              }
            }
            .onAppear {
              UIScrollView.appearance().isPagingEnabled = true
            }
          }
        }
        .background(.grayBack)
        .ignoresSafeArea(.all)
      }
      
      // MARK: - Camera Opened
      .fullScreenCover(isPresented: viewStore.$showCamSheet, content: {
        ImagePicker(sourceType: .camera, selectedImage: viewStore.$uiImg, isSelected: viewStore.$isCamPhotoOpened)
          .ignoresSafeArea()
      })
      
      // MARK: - Gallery Opened
      
      .sheet(isPresented: viewStore.$isGalleryOpened, content: {
        ImagePicker(sourceType: .photoLibrary, selectedImage: viewStore.$uiImg, isSelected: viewStore.$isGalleryOpened)
          .ignoresSafeArea()
      })
      
      // MARK: - Image Stored
      .onChange(of: viewStore.$uiImg) { _ in
        viewStore.send(.loadData(viewStore.uiImg.pngData()!))
        viewStore.send(.photoSelectionCompleted)
      }
      
      // MARK: - Navigation to MainView (Tree-Based)
      .navigationDestination(
        store: self.store.scope(state: \.$mainView, action: { .mainView($0) })
      ){ store in
        MainView(store: store)
      }
    }
  }
}
