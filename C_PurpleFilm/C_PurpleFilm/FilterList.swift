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
let filters : [CIFilter] = [
  CIFilter.photoEffectChrome()
]



class FilterList{
  
  // Coefficient
  @Published var redCo: CGFloat = 1.0
  @Published var greenCo: CGFloat = 1.0
  @Published var blueCo: CGFloat = 1.0
  
  
  //ColorMatrix
  @Published var redCoeff: Double = 1.0
  @Published var greenCoeff: Double = 1.0
  @Published var blueCoeff: Double = 1.0
  @Published var brightness: Double = 0.0
  
  
  func amplifyPurpleColor(imgData: Data) -> Data {
    
    var uiImage = UIImage()
    
    // Convert UIImage to CIImage
    let ciImage = CIImage(data: imgData)
    
    let redCoefficients = CIVector(values: [redCo, 0, 0, 0.5], count: 3)   // Increase red channel
    let greenCoefficients = CIVector(values: [0, greenCo, 0, 0.2], count: 3)  // Increase green channel
    let blueCoefficients = CIVector(values: [0, 0, blueCo, 0.2], count: 3)  // Increase blue channel
    
    // Create CIColorCrossPolynomial filter
    let crossPolynomialFilter = CIFilter.colorCrossPolynomial()
    crossPolynomialFilter.inputImage = ciImage
    
    // Set custom coefficients to amplify purple color
    crossPolynomialFilter.setValue(redCoefficients, forKey: "inputRedCoefficients")
    crossPolynomialFilter.setValue(greenCoefficients, forKey: "inputGreenCoefficients")
    crossPolynomialFilter.setValue(blueCoefficients, forKey: "inputBlueCoefficients")
    
    
    // Get the filtered output image
    if let outputImage = crossPolynomialFilter.outputImage {
      
      let context = CIContext()
      if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        print("stored UIImage")
        uiImage = UIImage(cgImage: cgImage)
      }
    }
    return uiImage.pngData()!
  }
  
  
  func applyMovieFilter(imgData: Data, styleNum: filterStyle) -> Data{
    // to avoid lag -> do it in background (Asynchronous)
    //  DispatchQueue.global(qos: .userInteractive).async {
    // loaidng Image into filter,,
    let CiImage = CIImage(data: imgData)
    
    let filter = filters[styleNum.rawValue]
    
    filter.setValue(CiImage!, forKey: kCIInputImageKey)
    
    // retreving Image,,,
    guard let newImage = filter.outputImage else {return imgData
    }
    
    return (UIImage(ciImage: newImage).pngData())!
    
    //   }
  }
  
  func applyEditFilter(imgData:Data, intensity: Float, kinds: editOpt) -> Data{
    
    // 1
    let uiImage = UIImage(data: imgData)
    
    let ciImage = CIImage(image: uiImage!)
    
    var filter = CIFilter(name: "CIColorControls")!
    
//    DispatchQueue.global(qos: .userInteractive).async {
      filter.setValue(ciImage, forKey: kCIInputImageKey)
      
      switch kinds{
      case .brightness:
        filter.setValue(intensity, forKey: kCIInputBrightnessKey)
        
      case .contrast:
        filter.setValue(intensity, forKey: kCIInputContrastKey)
        
      case .saturation:
        filter.setValue(intensity, forKey: kCIInputSaturationKey)
        
      case .sharpen:
        if let filterSharp = CIFilter(name: "CIUnsharpMask"){
          filter = filterSharp
          filter.setValue(ciImage, forKey: kCIInputImageKey)
          filter.setValue(7, forKey: kCIInputIntensityKey)
          filter.setValue(intensity, forKey: kCIInputIntensityKey)
          
        }else{
          print("none")
        }
      }
//    }
    
    
    if let output = filter.outputImage{
      return UIImage(ciImage: output).pngData()!
    } else{
      print("Not adapted")
      return imgData
    }
  }
  
  
}







