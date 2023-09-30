//
//  FilmFeature.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/11.
//

import SwiftUI
import PhotosUI

import ComposableArchitecture

// 스크롤뷰를 위함 => 17이전 버전도 허용할려면 UIKit 활용
@available(iOS 17.0, *)

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
      VStack{
        // MARK: - Tab Menu Bar
        HStack (spacing: 20){
          Button {
            viewStore.send(.camButtonTapped)
          } label: {
            Image(systemName: "camera.fill")
              .font(.system(size: 22))
          }
          Spacer()
          
          Button {
            viewStore.send(.galleryButtonTapped)
          } label: {
            Image(systemName: "photo.fill")
.font(.system(size: 22))
          }
        }
        .padding([.leading, .trailing, .bottom], 16)
        .foregroundColor(.black)
        
        // MARK: - ScrollView BGI
        GeometryReader { gr in
          ScrollViewReader{ value in
            ScrollView(.vertical){
              ForEach(bgI.bgImages.indices, id: \.self){ index in
                
                VStack{
                  ZStack{
                    Image(bgI.bgImages[index].name)
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: gr.size.width)
                      .id(bgI.bgImages[index].id)
                  
                    HStack{
                      Image(systemName: "at")
                      Text(bgI.bgLocation[index])
                        .id(bgI.bgImages[index].id)
                      Spacer()
                    }
                    .padding()
                  }
                  
                  // Button Gesture in Images
                  HStack{
                    Spacer()
                    VStack{
                      Button {
                        if index-1 >= 0{
                          withAnimation{
                            value.scrollTo(index-1)
                          }
                        }
                      } label: {
                        Image(systemName: "chevron.up")
                          .padding()
                      }
                      Text("\(index+1) / 20")
                        .padding()
                      Button {
                        if index+1 < 20{
                          withAnimation{
                            value.scrollTo(index+1)
                          }
                        }
                      } label: {
                        Image(systemName: "chevron.down")
                          .padding()
                      }
                    }
                    .foregroundColor(.black)
                  }
                  .padding([.bottom], gr.size.height/10)
                  
                }
                .frame(width: gr.size.width, height: gr.size.height)
              }
            }
            .scrollTargetBehavior(.paging)
          }
        }
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
