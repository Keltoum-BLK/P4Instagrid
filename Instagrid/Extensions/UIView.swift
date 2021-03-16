//
//  UIView.swift
//  Instagrid
//
//  Created by Keltoum Belkadi on 04/03/2021.
//

import Foundation
import UIKit

extension UIView {
//MARK: Use to implement a method to convert from UIVIEW to UIImage
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

