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
        }
        
        Spacer()
        
        HStack{
          ForEach(MainViewFeature.State.tapInfo.allCases, id: \.self) { item in
            VStack{
              Text(item.rawValue)
                .font(.title3)
                .frame(maxWidth: .infinity/5, minHeight: 30)
                .foregroundColor(viewStore.seletedPicker == item ? .accentColor : .gray)
              
              if viewStore.seletedPicker == item{
                Capsule()
                  .foregroundColor(.accentColor)
                  .frame(height: 2)
                  .matchedGeometryEffect(id: "info", in: animation)
              }
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
        } .padding(EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 30))
        
        Spacer()
        
        Button{
          
          viewStore.send(.saveImgButtonTapped)
        }label: {
          Image(systemName: "camera")
        }
      }.padding()
      
      
      // MARK: - Image View
      
      VStack{
        Image(uiImage: viewStore.editedImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: UIScreen.main.bounds.width ,height: viewStore.movieFilm.isSize16 ? UIScreen.main.bounds.width/16*9 : UIScreen.main.bounds.width/21*9)
          .clipped()
          .background(.black)
      }.frame(height: UIScreen.main.bounds.height/3)
        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/4)
      

      
      
      if viewStore.seletedPicker == .movie{
        MovieFilmView(store:
                        self.store.scope(state: \.movieFilm, action: MainViewFeature.Action.movieFilm))
        
      } else
      {
        
      }
    }.navigationBarBackButtonHidden(true)
    
  }
  
}

