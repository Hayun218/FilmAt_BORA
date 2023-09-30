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
      HStack{
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.backward")
            .font(.system(size: 18))
            .foregroundColor(.accent100)
        }
        
        Spacer()
        
        HStack{
          ForEach(MainViewFeature.State.tapInfo.allCases, id: \.self) { item in
            VStack{
              Text(item.rawValue)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: item.rawValue == "edit" ? 70 : 140, height: 25)
                .foregroundColor(viewStore.seletedPicker == item ? .accent100 : .gray)
              
              //                            if viewStore.seletedPicker == item{
              //                              Capsule()
              //                                .foregroundColor(.accentColor)
              //                                .frame(height: 1)
              //                                .matchedGeometryEffect(id: "info", in: animation)
              //                            }
            }
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
        }
        //TODO: - add line
        
        Spacer()
        
        Button{
          viewStore.send(.saveImgButtonTapped)
        }label: {
          Image(systemName: "arrow.down.to.line")
            .font(.system(size: 18))
            .foregroundColor(.accent100)
        }
      }
      .padding(EdgeInsets(top: 10, leading: 30, bottom: 25, trailing: 30))
      
      HStack{
        Spacer()
        Button {
          viewStore.send(.showOnlyImageButtonTapped)
        } label: {
          Image(systemName: viewStore.onlyShowImage ? "seal.fill" : "seal")
            .foregroundColor(.accent100)
            .font(.system(size: 18))
            .padding([.trailing, .bottom], 17)
        }
      }
      
      
      // MARK: - Image View
      VStack{
        if viewStore.editFilm.isFiltering && viewStore.seletedPicker == .edit{
          let uiImg = UIImage(data: viewStore.filteringData!)
          
          ZStack(alignment: .center){
            
            Spacer()
              .frame(width: UIScreen.screenWidth,
                     height: UIScreen.screenWidth/4*3)
              .background(.black)
            
            Image(uiImage: uiImg!)
              .resizable()
              .scaledToFill()
              .frame(width: UIScreen.screenWidth,
                     height: UIScreen.screenWidth/16*9)
              .clipped()
          }
          
        } else{
          
          ZStack(alignment: .center){
            
            Spacer()
              .frame(width: UIScreen.screenWidth,
                     height: UIScreen.screenWidth/4*3)
            //height: UIScreen.screenWidth/2.35)
              .background(.black)
            
            Image(uiImage: viewStore.editedImage)
              .resizable()
              .scaledToFill()
              .frame(width: UIScreen.screenWidth,
                     height: UIScreen.screenWidth/16*9)
              .clipped()
            //            .gesture(
            //            LongPressGesture()
            //              .onChanged({ _ in
            //
            //              })
            //              .onEnded({ _ in
            //                <#code#>
            //              })
            //            )
          }
        }
      }
      .frame(height: UIScreen.main.bounds.height/2.5)
      .padding([.top], 17)
      .position(x: UIScreen.main.bounds.width/2, y: viewStore.movieFilm.isKeyboardVisible ? UIScreen.main.bounds.height/4.5 - 50: UIScreen.main.bounds.height/4.5)
      
      
      if !viewStore.onlyShowImage{
        
        if viewStore.seletedPicker == .movie{
          MovieFilmView(store:
                          self.store.scope(state: \.movieFilm, action: MainViewFeature.Action.movieFilm))
          //   .adaptsToKeyboard()
          
          
        } else
        {
          EditFilmView(store: self.store.scope(state: \.editFilm, action: MainViewFeature.Action.editFilm))
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .background(Color(hex: 0xE9E9E9))
    .alert(isPresented: viewStore.$showStoreAlert) {
      Alert(title: Text("저장 완료"), message: Text("이미지가 저장되었습니다."), dismissButton: .default(Text("확인")))
    }
  }
}
