//
//  FilterList.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/14.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class FilterList{
  
  var sharpenFilter = CIFilter(name: "CIUnsharpMask")!
  
  func applySharpenFilter(imgData:Data, intensity: Float) -> Data{
    
    let uiImage = UIImage(data: imgData)
    
    let ciImage = CIImage(image: uiImage!)
    
    sharpenFilter.setValue(ciImage, forKey: kCIInputImageKey)
    sharpenFilter.setValue(intensity, forKey: kCIInputIntensityKey)
    if let output = sharpenFilter.outputImage{
      return UIImage(ciImage: output).pngData()!
    } else{
      print("Not adapted")
      return imgData
    }
  }
}
