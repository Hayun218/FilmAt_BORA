//
//  FilterList.swift
//  C_PurpleFilm
//
//  Created by yun on 2023/09/14.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


// filterOptions
let movieFilters : [CIFilter] = [
  CIFilter.photoEffectChrome()
  
]




class FilterList{
  
  
  var sharpenFilter = CIFilter(name: "CIUnsharpMask")!
  
  
//  func applyMovieFilter(imgData: Data, styleNum: filterStyle) -> Data{
//    // to avoid lag -> do it in background (Asynchronous)
//    //  DispatchQueue.global(qos: .userInteractive).async {
//    // loaidng Image into filter,,
//    let CiImage = CIImage(data: imgData)
//    
//    let filter = movieFilters[styleNum.rawValue]
//    
//    filter.setValue(CiImage!, forKey: kCIInputImageKey)
//    
//    // retreving Image,,,
//    guard let newImage = filter.outputImage else {return imgData
//    }
//    
//    return (UIImage(ciImage: newImage).pngData())!
//    
//    //   }
//  }
  
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
