//
//  TabBarView.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/16.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

import ComposableArchitecture

struct MainView: View{
  let store: StoreOf<MainViewFeature>
  
  @ObservedObject private var viewStore: ViewStoreOf<MainViewFeature>
  
  @Environment(\.dismiss) private var dismiss
  
  @Namespace var animation
  
  public init(store: StoreOf<MainViewFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }
  
  var body: some View{
    
    VStack{
      // MARK: - TabBar
      VStack{
        HStack{
          Button {
            dismiss()
          } label: {
            Image(systemName: "chevron.backward")
              .font(.system(size: 18))
              .foregroundColor(.black)
          }
          Spacer()
          ForEach(MainViewFeature.State.tapInfo.allCases, id: \.self) { item in
            
            Text(item.rawValue)
              .font(.system(size: 16, weight: .semibold))
              .frame(width: item.rawValue == "edit" ? 70 : 140, height: 25)
              .foregroundColor(viewStore.seletedPicker == item ? .black : .gray200)
            
              .onTapGesture {
                withAnimation(.easeInOut){
                  if item == .movie {
                    viewStore.send(.tapMovieTapped)
                  } else{
                    viewStore.send(.tapEditTapped)
                  }
                }
              }
          }
          
          Spacer()
          
          Button{
            let renderer = ImageRenderer(content: ImageWithBoxView(
              uiImage:viewStore.displayedUIImage,
              isOriginal: false,
              originalUIImage: nil,
              brightness: viewStore.editFilm.brightnessV,
              contrast: viewStore.editFilm.contrastV,
              saturation: viewStore.editFilm.saturationV,
              textOnImg: viewStore.movieFilm.textOnImg,
              fontName: viewStore.movieFilm.selectedFont.rawValue,
              fontSize: viewStore.movieFilm.fontSize.rawValue,
              fontColor: viewStore.movieFilm.fontColor.rawValue,
              grainStyle: viewStore.movieFilm.grainStyle.rawValue,
              filterType: viewStore.movieFilm.currentFilter))
            renderer.scale = 6.0
            
            if let image = renderer.uiImage{
              viewStore.send(.saveImgButtonTapped(image))
            }
          }label: {
            Image(systemName: "arrow.down.to.line")
              .font(.system(size: 18))
              .foregroundColor(.black)
          }
        }
        // indicator
        HStack(alignment: .center, spacing: 0){
          Rectangle()
            .fill(viewStore.seletedPicker == .edit ? .gray100 : .accent100)
            .frame(width: 150, height: 5)
          Rectangle()
            .fill(viewStore.seletedPicker == .edit ? .accent100 : .gray100)
            .frame(width: 70, height: 5)
        }
      }
      .padding(EdgeInsets(top: 10, leading: 30, bottom: 25, trailing: 30))
      
      //MARK: - Movie Main Body
      HStack{
        Button {
          viewStore.send(.cropEnabledButtonTapped)
        } label: {
          Image(systemName: viewStore.isCropEnabled ? "checkmark" : "grid")
            .foregroundStyle(viewStore.isCropEnabled ? .accent100 : .black)
        }
        
        Spacer()
        Button {
          viewStore.send(.showOriginalImgButtonTapped)
        } label: {
          Image(systemName: "seal")
            .foregroundStyle(viewStore.isOriginalImg ? .accent100 : .black)
        }
      }
      .font(.system(size: 18))
      .padding([.leading, .trailing, .bottom], 17)
      
      
      // MARK: - Image View
      
      if viewStore.isCropEnabled == true{
        
        if viewStore.isOriginalImg == true{
          
          CropView(store: self.store.scope(
            state: \.cropView,
            action: MainViewFeature.Action.cropView),
                   uiImage: UIImage(data:viewStore.originalData)!)
          
        }else{
          CropView(store: self.store.scope(
            state: \.cropView,
            action: MainViewFeature.Action.cropView),
                   uiImage: UIImage(data:viewStore.originalData)!,
                   brightness: viewStore.editFilm.brightnessV,
                   contrast: viewStore.editFilm.contrastV,
                   saturation: viewStore.editFilm.saturationV,
                   textOnImg: viewStore.movieFilm.textOnImg,
                   fontName: viewStore.movieFilm.selectedFont.rawValue,
                   fontSize: viewStore.movieFilm.fontSize.rawValue,
                   fontColor: viewStore.movieFilm.fontColor.rawValue)
        }
      }
      else{
        VStack{
          ImageWithBoxView(uiImage: viewStore.displayedUIImage,
                           isOriginal: viewStore.isOriginalImg,
                           originalUIImage: UIImage(data: viewStore.originalData)!,
                           brightness: viewStore.editFilm.brightnessV,
                           contrast: viewStore.editFilm.contrastV,
                           saturation: viewStore.editFilm.saturationV,
                           textOnImg: viewStore.movieFilm.textOnImg,
                           fontName: viewStore.movieFilm.selectedFont.rawValue,
                           fontSize: viewStore.movieFilm.fontSize.rawValue,
                           fontColor: viewStore.movieFilm.fontColor.rawValue, grainStyle: viewStore.movieFilm.grainStyle.rawValue,filterType: viewStore.movieFilm.currentFilter)
          
          
          
        }
        .frame(height: UIScreen.main.bounds.height/2.5)
        .padding([.top], 17)
        .position(x: UIScreen.main.bounds.width/2,
                  y: viewStore.movieFilm.isKeyboardVisible ? UIScreen.main.bounds.height/4.5 - 50 : UIScreen.main.bounds.height/4.5)
      }
      
      
      // MARK: - each Tab Views
      if !viewStore.isCropEnabled{
        
        if viewStore.seletedPicker == .movie{
          MovieFilmView(store: self.store.scope(state: \.movieFilm,
                                                action: MainViewFeature.Action.movieFilm))
          
        } else
        {
          EditFilmView(store: self.store.scope(state: \.editFilm,
                                               action: MainViewFeature.Action.editFilm))
          .onAppear {
            viewStore.send(.editButtonReset)
          }
          
        }
      }
    }
    .onAppear(perform: {
      if viewStore.originalCropData == nil{
        let renderer = ImageRenderer(content: ImageView(uiImage: viewStore.displayedUIImage))
        renderer.scale = 6.0
        
        if let image = renderer.uiImage!.pngData(){
          viewStore.send(.initCropImg(image))
        }
      }
    })
    .navigationBarBackButtonHidden(true)
    .background(.grayBack)
    .alert(isPresented: viewStore.$showStoreAlert) {
      Alert(title: Text("저장 완료"), message: Text("이미지가 저장되었습니다."), dismissButton: .default(Text("확인")))
    }
  }
}
