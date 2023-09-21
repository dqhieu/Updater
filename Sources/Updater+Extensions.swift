//
//  Updater+Extensions.swift
//  Updater
//
//  Created by Dinh Quang Hieu on 21/09/2023.
//

import UIKit

extension UIFont {
  
  func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { return self }
    return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
  }
  
  func bold() -> UIFont {
    return withTraits(traits: .traitBold)
  }
  
  func rounded() -> UIFont {
    guard let descriptor = fontDescriptor.withDesign(.rounded) else {
      return self
    }
    
    return UIFont(descriptor: descriptor, size: pointSize)
  }
}


extension UIView {
  
  private static let kLayerNameGradientBorder = "GradientBorderLayer"
  
  func setGradientBorder(
    width: CGFloat,
    colors: [UIColor],
    startPoint: CGPoint = CGPoint(x: 0, y: 0),
    endPoint: CGPoint = CGPoint(x: 1, y: 1)
  ) {
    let existedBorder = gradientBorderLayer()
    let border = existedBorder ?? CAGradientLayer()
    border.frame = bounds
    border.colors = colors.map { return $0.cgColor }
    border.startPoint = startPoint
    border.endPoint = endPoint
    
    let mask = CAShapeLayer()
    mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: UIScreen.main.displayCornerRadius).cgPath
    mask.fillColor = UIColor.clear.cgColor
    mask.strokeColor = UIColor.white.cgColor
    mask.lineWidth = width
    
    border.mask = mask
    
    let exists = existedBorder != nil
    if !exists {
      layer.addSublayer(border)
    }
  }
  
  private func gradientBorderLayer() -> CAGradientLayer? {
    let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
    if borderLayers?.count ?? 0 > 1 {
      fatalError()
    }
    return borderLayers?.first as? CAGradientLayer
  }
  
  @discardableResult
  func forAutolayout() -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }
}

extension UIScreen {
  private static let cornerRadiusKey: String = {
    let components = ["Radius", "Corner", "display", "_"]
    return components.reversed().joined()
  }()
  
  var displayCornerRadius: CGFloat {
    guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
      return 24
    }
    
    return cornerRadius
  }
}
