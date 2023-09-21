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
      Spacer()
      
      switch viewStore.editButton{
        
      case .brightness:
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(hex: 0xD9D9D9))
              .frame(width: 327, height: 44)
            
            HStack(spacing: 10){
              
              CenterOriginSliderSpecific(minValue: -0.5, maxValue: 0.5, increment: 0.1, sliderValue: viewStore.$brightnessV)
                .onChange(of: viewStore.$brightnessV) { _ in
                  
                  DispatchQueue.main.async {
                    viewStore.send(.applySliders(.brightness))
                  }
                }
              Text("\(Int(viewStore.brightnessV*100))")
              Button {
                viewStore.send(.applyButtonTapped(.brightness))
              } label: {
                Image(systemName: "checkmark")
              }
            }
            .padding([.trailing, .leading], 10)
          }
          HStack{
            TriangleViewSpecific()
            Spacer()
              .frame(width: (UIScreen.main.bounds.width/10) * 7)
          }
          
        }
        
      case .contrast:
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(hex: 0xD9D9D9))
              .frame(width: 327, height: 44)
            
            HStack(spacing: 10){
              CenterOriginSliderSpecific(minValue: -1, maxValue: 1, increment: 0.2, sliderValue: viewStore.$contrastV)
              .onChange(of: viewStore.$contrastV) { _ in
                DispatchQueue.main.async {
                  viewStore.send(.applySliders(.contrast))
                }
              }
              Text("\(Int(viewStore.contrastV*100))")
              Button {
                viewStore.send(.applyButtonTapped(.contrast))
              } label: {
                Image(systemName: "checkmark")
              }
            }
            .padding([.trailing, .leading], 10)
          }
          HStack{
            TriangleViewSpecific()
            Spacer()
              .frame(width: UIScreen.screenWidth/5)
          }
          
        }
        
        
      case .saturation:
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(hex: 0xD9D9D9))
              .frame(width: 327, height: 44)
            
            HStack(spacing: 10){
              CenterOriginSliderSpecific(minValue: -1, maxValue: 1, increment: 0.2, sliderValue: viewStore.$saturationV)
              .onChange(of: viewStore.$contrastV) { _ in
                DispatchQueue.main.async {
                  viewStore.send(.applySliders(.saturation))
                }
              }
              Text("\(Int(viewStore.saturationV*100))")
              Button {
                viewStore.send(.applyButtonTapped(.saturation))
              } label: {
                Image(systemName: "checkmark")
              }
            }
            .padding([.trailing, .leading], 10)
          }
          HStack{
            Spacer()
              .frame(width: UIScreen.screenWidth/5)
            TriangleViewSpecific()
          }
        }
        
        
      case .sharpen:
        
        VStack{
          ZStack{
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(hex: 0xD9D9D9))
              .frame(width: 327, height: 44)
            
            HStack(spacing: 10){
              CenterOriginSliderSpecific(minValue: -5, maxValue: 5, increment: 0.2, sliderValue: viewStore.$sharpenV)
              .onChange(of: viewStore.$sharpenV) { _ in
                DispatchQueue.main.async {
                  viewStore.send(.applySliders(.sharpen))
                }
              }
              Text("\(Int(viewStore.sharpenV*20))")
              Button {
                viewStore.send(.applyButtonTapped(.sharpen))
              } label: {
                Image(systemName: "checkmark")
              }
            }
            .padding([.trailing, .leading], 10)
          }
          HStack{
            Spacer()
              .frame(width: (UIScreen.main.bounds.width/10) * 7)
            TriangleViewSpecific()
          }
        }
        
      default:
        Text("none").foregroundColor(.clear)
      }
      
      HStack(spacing: 29){
        ForEach(editOpt.allCases, id: \.self) { item in
          
          switch item{
            
          case .brightness:
            let isSelected: Bool = viewStore.editButton == .brightness
            Button {
              viewStore.send(.editOptButtonTapped(.brightness))
            } label: {
              VStack{
                Image(systemName: "sun.min")
                  .foregroundColor(Color(hex: isSelected ? 0xB367FF :0x1C1C1E))
                  .frame(width: buttonSize, height: buttonSize)
                  .background(Color(hex: 0xD9D9D9))
                  .clipShape(Circle())
                
                Text("BRIGHT")
                  .font(.system(size: 10))
                  .foregroundColor(Color(hex: 0x747474))
              }
             
            }
            
          case .contrast:
            let isSelected: Bool = viewStore.editButton == .contrast
            Button {
              viewStore.send(.editOptButtonTapped(.contrast))
            } label: {
              VStack{
                Image(systemName: "circle.lefthalf.filled")
                  .frame(width: buttonSize, height: buttonSize)
                  .foregroundColor(Color(hex: isSelected ? 0xB367FF :0x1C1C1E))
                  .background(Color(hex:0xD9D9D9))
                  .clipShape(Circle())
                
                Text("CONTRAST")
                  .font(.system(size: 10))
                  .foregroundColor(Color(hex: 0x747474))
              }
              
              
            }
            
          case .saturation:
            let isSelected: Bool = viewStore.editButton == .saturation
            Button {
              viewStore.send(.editOptButtonTapped(.saturation))
            } label: {
              VStack{
                Image(systemName: "drop")
                  .frame(width: buttonSize, height: buttonSize)
                  .foregroundColor(Color(hex: isSelected ? 0xB367FF :0x1C1C1E))
                  .foregroundColor(Color(hex: isSelected ? 0xB367FF :0x1C1C1E))
                  .background(Color(hex: 0xD9D9D9))
                  .clipShape(Circle())
                
                Text("SATURATION")
                  .font(.system(size: 9))
                  .foregroundColor(Color(hex: 0x747474))
              }
              
            }
          case .sharpen:
            let isSelected: Bool = viewStore.editButton == .sharpen
            Button {
              viewStore.send(.editOptButtonTapped(.sharpen))
            } label: {
              VStack{
                Image(systemName: "triangle")
                  .frame(width: buttonSize, height: buttonSize)
                  .foregroundColor(Color(hex: isSelected ? 0xB367FF :0x1C1C1E))
                  .background(Color(hex: 0xD9D9D9))
                  .clipShape(Circle())
                
                Text("SHARPEN")
                  .font(.system(size: 10))
                  .foregroundColor(Color(hex: 0x747474))
              }
            }
            
          }
          
        }
        
      }
      .padding([.leading, .trailing], 24)
      .padding(.bottom, 37)
    }
    
  }
}
