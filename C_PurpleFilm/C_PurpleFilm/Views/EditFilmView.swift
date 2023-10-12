////
////  EditFilmView.swift
////  C_PurpleFilm
////
////  Created by yun on 2023/09/17.
////
//
import SwiftUI

import CenterOriginSlider
import ComposableArchitecture




enum editOpt: String, CaseIterable{
  case brightness = "brightness"
  case contrast = "contrast"
  case saturation = "saturation"
  case sharpen = "sharpen"
}

struct EditFilmView: View{
  
  let store: StoreOf<EditFilmFeature>
  
  @ObservedObject var viewStore: ViewStoreOf<EditFilmFeature>
  
  public init(store: StoreOf<EditFilmFeature>){
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }
  
  let buttonSize: CGFloat = 60
  
  var body: some View{
    VStack{
      // Spacer()
      
      // Stack View location stable,,
      HStack{
        Text("Hello")
          .foregroundStyle(.clear)
        
      }
      HStack{
        Spacer()
        Button {
          viewStore.send(.resetButtonTapped)
        } label: {
          Image(systemName: "arrow.uturn.backward")
            .font(.system(size: 18))
        }
        
        
      }
      .foregroundColor(.black)
      .padding()
      
      Spacer()
      
      
      switch viewStore.editButton{
        
      case .brightness:
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(hex: 0xD9D9D9))
              .frame(width: 327, height: 44)
            
            CenterOriginSliderSpecific(minValue: -0.5, maxValue: 0.5, increment: 0.1, sliderValue: viewStore.$brightnessV)
            
          }
          
          TriangleViewSpecific(width: (UIScreen.main.bounds.width/10) * 7, isUp: false)
            
          
        }
        
      case .contrast:
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(hex: 0xD9D9D9))
              .frame(width: 327, height: 44)
            
            
            CenterOriginSliderSpecific(minValue: -2, maxValue: 2, increment: 0.2, sliderValue: viewStore.$contrastV)
            
          }
          
            TriangleViewSpecific(width:  UIScreen.screenWidth/5, isUp: false)
           
          
        }
        
        
      case .saturation:
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(hex: 0xD9D9D9))
              .frame(width: 327, height: 44)
            
            
            CenterOriginSliderSpecific(minValue: -1, maxValue: 1, increment: 0.2, sliderValue: viewStore.$saturationV)
            
            
              .padding([.trailing, .leading], 10)
          }
         
          TriangleViewSpecific(width: UIScreen.screenWidth/5, isUp: true)
        }
        
      case .sharpen:
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(.grayButton)
              .frame(width: 327, height: 44)
            
            
            CenterOriginSliderSpecific(minValue: -5, maxValue: 5, increment: 0.2, sliderValue: viewStore.$sharpenV)
              .onChange(of: viewStore.$sharpenV) { _ in
                DispatchQueue.main.async {
                  viewStore.send(.applySharpend)
                }
              }
            
          }
          TriangleViewSpecific(width: (UIScreen.main.bounds.width/10) * 7, isUp: true)
        }
        
      default:
        Spacer()
          .frame(width: 327, height: 90)
      }
      
      HStack(spacing: 29){
        ForEach(editOpt.allCases, id: \.self) { item in
          
          switch item{
            
          case .brightness:
            let isSelected: Bool = viewStore.editButton == .brightness
            Button {
              viewStore.send(.editOptButtonTapped(.brightness))
            } label: {
              ButtonLabel(img: "sun.min", isSelected: isSelected, text: "BRIGHT")
            }
            
          case .contrast:
            let isSelected: Bool = viewStore.editButton == .contrast
            Button {
              viewStore.send(.editOptButtonTapped(.contrast))
            } label: {
              ButtonLabel(img: "circle.lefthalf.filled", isSelected: isSelected, text: "CONTRAST")
            }
            
          case .saturation:
            let isSelected: Bool = viewStore.editButton == .saturation
            Button {
              viewStore.send(.editOptButtonTapped(.saturation))
            } label: {
              
              ButtonLabel(img: "drop", isSelected: isSelected, text: "SATURATION")
              
            }
          case .sharpen:
            let isSelected: Bool = viewStore.editButton == .sharpen
            Button {
              viewStore.send(.editOptButtonTapped(.sharpen))
            } label: {
              // TODO: Icon Change
              ButtonLabel(img: "triangle", isSelected: isSelected, text: "SHARPEN")
            }
          }
        }
      }
      .padding([.leading, .trailing], 24)
      .padding(.bottom, 37)
    }
  }
}
