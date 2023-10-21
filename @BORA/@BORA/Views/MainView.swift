//
//  TabBarView.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/16.
//

import SwiftUI
import CoreImage


import ComposableArchitecture

struct MainView: View{
  let store: StoreOf<MainViewFeature>
  
  @Environment(\.dismiss) private var dismiss
  @Namespace var animation
  
  @ObservedObject private var viewStore: ViewStoreOf<MainViewFeature>
  
  public init(store: StoreOf<MainViewFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }
  
  var body: some View{
    ZStack{
      
      VStack{
        // MARK: - TabBar
        
        VStack{
          // 뒤로 가기 버튼
          HStack {
            Button {
              viewStore.send(.returnToMainButtonTapped)
            } label: {
              Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundColor(.black)
            }
            Spacer()
            
            // 탭 2개
            ForEach(MainViewFeature.State.tapInfo.allCases, id: \.self) { item in
              
              Text(item.rawValue)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: item.rawValue == "edit" ? 70 : 140, height: 25)
                .foregroundColor(viewStore.seletedPicker == item ? .black : .gray200)
              
                .onTapGesture {
                  withAnimation(.easeInOut) {
                    if item == .movie {
                      viewStore.send(.tapMovieTapped)
                    } else{
                      viewStore.send(.tapEditTapped)
                    }
                  }
                }
            }
            
            Spacer()
            
            // 저장하기 버튼
            Button {
              let renderer = ImageRenderer(content: ImageWithBoxView(
                uiImage:viewStore.displayedUIImage,
                brightness: viewStore.editFilm.brightnessV,
                contrast: viewStore.editFilm.contrastV,
                saturation: viewStore.editFilm.saturationV,
                textOnImg: viewStore.movieFilm.textOnImg,
                fontName: viewStore.movieFilm.selectedFont.rawValue,
                fontSize: viewStore.movieFilm.fontSize.rawValue,
                fontType: viewStore.movieFilm.fontType.rawValue,
                grainStyle: viewStore.movieFilm.grainStyle.rawValue,
                filterType: viewStore.movieFilm.currentFilter))
              renderer.scale = 6.0
              
              if let image = renderer.uiImage {
                viewStore.send(.saveImgButtonTapped(image))
              }
            }label: {
              Image(systemName: "arrow.down.to.line")
                .font(.system(size: 18))
                .foregroundColor(.black)
            }
          }
          
          // indicator
          HStack(alignment: .center, spacing: 0) {
            Rectangle()
              .fill(viewStore.seletedPicker == .edit ? .gray100 : .accent100)
              .frame(width: 150, height: 5)
            Rectangle()
              .fill(viewStore.seletedPicker == .edit ? .accent100 : .gray100)
              .frame(width: 70, height: 5)
          }
        }
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 25, trailing: 30))
        
        //MARK: - Main Options
        
        HStack {
          Button {
            viewStore.send(.cropEnabledButtonTapped)
          } label: {
            Image(systemName: viewStore.isCropEnabled ? "checkmark" : "grid")
              .background(
                Circle()
                  .fill(.white.opacity(0.6))
                  .frame(width: 30, height: 30)
                
              )
              .foregroundStyle(viewStore.isCropEnabled ? .accent100 : .black)
            
          }
          
          Spacer()
          Button {
            viewStore.send(.showOriginalImgButtonTapped)
          } label: {
            Image(systemName: "seal")
              .background(
                Circle()
                  .fill(.white.opacity(0.6))
                  .frame(width: 30, height: 30)
                
              )
              .foregroundStyle(viewStore.isOriginalImg ? .accent100 : .black)
          }
        }
        .font(.system(size: 18))
        .padding([.leading, .trailing, .bottom], 17)
        
        // MARK: - Image View
        
        if viewStore.isCropEnabled == true {
          // CropView
          CropView(store: self.store.scope(
            state: \.cropView,
            action: MainViewFeature.Action.cropView),
                   uiImage: UIImage(data:viewStore.originalData)!)
        }
        else {
          // Main 화면 이미지
          VStack {
            if viewStore.isOriginalImg == true {
              // Original Img
              ImageWithBoxView(uiImage: viewStore.displayedUIImage,
                               isOriginal: true,
                               originalUIImage: UIImage(data:viewStore.originalCropData!)!)
            } else {
              // 기본 Edited Img
              ImageWithBoxView(uiImage: viewStore.displayedUIImage,
                               brightness: viewStore.editFilm.brightnessV,
                               contrast: viewStore.editFilm.contrastV,
                               saturation: viewStore.editFilm.saturationV,
                               textOnImg: viewStore.movieFilm.textOnImg,
                               fontName: viewStore.movieFilm.selectedFont.rawValue,
                               fontSize: viewStore.movieFilm.fontSize.rawValue,
                               fontType: viewStore.movieFilm.fontType.rawValue,
                               grainStyle: viewStore.movieFilm.grainStyle.rawValue,
                               filterType: viewStore.movieFilm.currentFilter)
              
            }
          }
          .frame(height: UIScreen.main.bounds.height/2.5)
          .padding([.top], 17)
          .position(x: UIScreen.main.bounds.width/2,
                    y: viewStore.movieFilm.isKeyboardVisible ? UIScreen.main.bounds.height/4.5 - 50 : UIScreen.main.bounds.height/4.5)
        }
        
        
        // MARK: - Tab Views
        
        if !viewStore.isCropEnabled{
          if viewStore.seletedPicker == .movie {
            MovieFilmView(store: self.store.scope(state: \.movieFilm,
                                                  action: MainViewFeature.Action.movieFilm))
          } else {
            EditFilmView(store: self.store.scope(state: \.editFilm,
                                                 action: MainViewFeature.Action.editFilm))
            .onAppear {
              viewStore.send(.editButtonReset)
            }
          }
        }
      }
    }
    
    // MARK: - OnBoarding
//    .overlay(content: {
//      UserDefaults.standard.bool(forKey: "isFirst") ?
//      OnBoardingView()
//      : nil
//    })
//    
//    .onAppear(perform: {
//      viewStore.send(.checkFirst)
//    })
//    
//    .onChange(of: UserDefaults.standard.bool(forKey: "isFirst"), perform: { _ in
//      viewStore.send(.checkFirst)
//    })
    
    
    
    // MARK: - MainView로 전환 Alert
    
    .alert("", isPresented: viewStore.$isReturned) {
      Button("취소", role: .cancel) {
        viewStore.send(.returnToMainButtonTapped)
      }
      Button {
        dismiss()
      } label: {
        Text("확인")
          .foregroundColor(.accent100)
      }
    } message: {
      Text("편집한 내용을 저장하지 않고 종료할까요?")
    }
    
    // MARK: - 저장완료 Alert
    
    .alert(isPresented: viewStore.$showStoreAlert) {
      Alert(title: Text("저장 완료"), message: Text("이미지가 저장되었습니다."),
            
            
            dismissButton: .default(Text("확인").foregroundColor(.accent100)))
      //    dismissButton: Alert.Button.default(
      //           Text("확인"), action: { dismiss() }
      //       )
      
    }
    
    //MARK: - 초기 이미지 Crop
    
    .onAppear(perform: {
      if viewStore.originalCropData == nil{
        let renderer = ImageRenderer(content: ImageView(uiImage: viewStore.displayedUIImage))
        renderer.scale = 6.0
        
        if let image = renderer.uiImage!.pngData(){
          viewStore.send(.initCropImg(image))
        }
      }
    })
    
    // MARK: - Crop에 맞추어 Render
    
    .onChange(of: viewStore.isCropEnabled) { newValue in
      if !newValue{
        let renderer = ImageRenderer(content: ImageView(uiImage: UIImage(data: viewStore.originalData)!, offset: viewStore.cropView.lastStoredOffset))
        renderer.scale = 6.0
        if let image = renderer.uiImage!.pngData(){
          viewStore.send(.initCropImg(image))
        }
      }
    }
    
    // MARK: - 그 외
    
    .navigationBarBackButtonHidden(true)
    .background(.grayBack)
    
  }
}
