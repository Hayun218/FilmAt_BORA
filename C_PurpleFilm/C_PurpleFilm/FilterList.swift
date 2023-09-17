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
  
  // Coefficient
  @Published var redCo: CGFloat = 1.0
  @Published var greenCo: CGFloat = 1.0
  @Published var blueCo: CGFloat = 1.0
  
  
  //ColorMatrix
  @Published var redCoeff: Double = 1.0
  @Published var greenCoeff: Double = 1.0
  @Published var blueCoeff: Double = 1.0
  @Published var brightness: Double = 0.0
  
  
  func amplifyPurpleColor(imgData: Data) -> UIImage {
    
    var uiImage: UIImage? = nil
    
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
    return uiImage!
  }
}
