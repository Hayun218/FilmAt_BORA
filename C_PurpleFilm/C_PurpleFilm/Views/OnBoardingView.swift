//
//  OnBoardingView.swift
//  C_PurpleFilm
//
//  Created by yun on 10/18/23.
//

import SwiftUI

struct OnBoardingView: View {
  var body: some View {
    VStack{
      Spacer()
        .frame(width: 60, height: 100)
      HStack{
        Text("Hello")
        Spacer()
      }
      .padding()
      .foregroundStyle(.white)
      
      
      VStack{
        Spacer()
        Button {
          UserDefaults.standard.set(false, forKey: "isFirst")
//          print(UserDefaults.standard.bool(forKey: "isFirst"))
        } label: {
          VStack{
            Image(systemName: "multiply.circle")
              .font(.system(size: 44))
              .padding(5)
            Text("안내 창 닫기")
              .font(.system(size: 12))
          }
          .foregroundStyle(.white)
        }
        Spacer()
          .frame(height: 74)
      }
    }
    .padding()
    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    .background( Color.black.opacity(0.3))
    
    .ignoresSafeArea()
    
  }
}
  
  #Preview {
    OnBoardingView()
  }
