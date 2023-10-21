//
//  MovieFilmView.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/17.
//d

import SwiftUI

import ComposableArchitecture

struct MovieFilmView: View{
  
  let store: StoreOf<MovieFilmFeature>
  
  @ObservedObject var viewStore: ViewStoreOf<MovieFilmFeature>
  
  public init(store: StoreOf<MovieFilmFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
    
    // font 확인
    //        for family in UIFont.familyNames.sorted() {
    //            let names = UIFont.fontNames(forFamilyName: family)
    //            print("Family: \(family) Font names: \(names)")
    //        }
  }
  
  var body: some View{
    
    VStack{
      
      // 키보드 올리면 안보이게 처리
      if !viewStore.isKeyboardVisible {
        
        // MARK: - Filter Options
        
        HStack(spacing: 15){
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterOne))
          } label: {
            FilterTextView(title: "LAVENDAR", filterType: viewStore.currentFilter, currentFilterType: "Lavendar")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterTwo))
          } label: {
            FilterTextView(title: "LILAC", filterType: viewStore.currentFilter, currentFilterType: "Lilac")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterThree))
            
          } label: {
            FilterTextView(title: "PLUM", filterType: viewStore.currentFilter, currentFilterType: "Plum")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterFour))
            
          } label: {
            FilterTextView(title: "VIOLET", filterType: viewStore.currentFilter, currentFilterType: "Violet")
          }
          Button {
            viewStore.send(.filterApplyButtonTapped(.filterFive))
            
          } label: {
            FilterTextView(title: "MOUVE", filterType: viewStore.currentFilter, currentFilterType: "Mouve")
          }
        }
        .padding([.leading, .trailing], 20)
        .offset(x: 0, y: -UIScreen.screenHeight/2.6)
      }
      
      
      // MARK: - 영화 자막 TextField
      
      HStack {
        Spacer()
        if viewStore.isTexting == true {
          withAnimation {
            TextField("자막을 입력하세요",
                      text: viewStore.$textOnImg,
                      axis: .vertical)
            .onChange(of: viewStore.$textOnImg, perform: { _ in
              viewStore.send(.checkTextLength)
            })
            .multilineTextAlignment(.center)
            .foregroundColor(.gray200)
          }
        }
        
        Spacer()
        
        Button {
          viewStore.send(.textAddButtonTapped)
        } label: {
          Image(systemName: viewStore.isTexting ? "checkmark" :"text.badge.plus")
            .font(.system(size: 18))
            .background(
              Circle()
                .fill(.grayButton.opacity(0.6))
                .frame(width: 30, height: 30)
              
            )
          
        }
      }
      .foregroundColor(.black)
      .padding()
      .offset(x: 0, y:  viewStore.isKeyboardVisible ? 120:0)
      
      // MARK: -MovieOpt
      
      Spacer()
      
      if !viewStore.isKeyboardVisible {
        
        HStack(spacing: 29){
          ForEach(movieOpt.allCases, id: \.self) { item in
            switch item{
              
            case .fontStyle:
              Button {
                viewStore.send(.fontStyleButtonTapped)
              } label: {
                ButtonLabelWithOverlay(img: "textformat", text: "FONT", index: viewStore.fontTypeIndex)
              }
              
            case .textSize:
              Button {
                viewStore.send(.fontSizeButtonTapped)
              } label: {
                ButtonLabelWithOverlay(img: "textformat.size", text: "SIZE", index: viewStore.fontSizeIndex)
              }
              
            case .textStyle:
              Button {
                viewStore.send(.styleButtonTapped)
              } label: {
                ButtonLabelWithOverlay(img: "circle.fill", text: "STYLE", index: viewStore.fontStyleIndex)
              }
              
            case .grain:
              Button {
                viewStore.send(.grainButtonTapped)
              } label: {
                VStack{
                  // 이미지 -> custom View 활용 X
                  Image("grainIcon")
                    .frame(width: 60, height: 60)
                    .background(.grayButton)
                    .clipShape(Circle())
                    .overlay(
                      RoundedRectangle(cornerRadius: 100)
                        .inset(by: 4)
                        .trim(from: 0, to: CGFloat(0.35))
                        .stroke(.accent50, lineWidth: 5)
                        .rotationEffect(.degrees(Double(viewStore.grainStyleIndex)*10))
                    )
                  Text("GRAIN")
                    .font(.system(size: 10))
                    .foregroundColor(.gray200)
                }
                .foregroundColor(.black)
              }
            }
          }
        }
        .padding([.leading, .trailing], 24)
        .padding(.bottom, 37)
      }
    }
    // 키보드 확인
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
      viewStore.send(
        .isKeyBoardAppeared(true))
    }
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
      viewStore.send(
        .isKeyBoardAppeared(false))
    }
    
  }
}
