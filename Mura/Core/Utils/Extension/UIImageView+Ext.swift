//
//  UIImageView+Ext.swift
//  Mura
//
//  Created by Ferry Dwianta P on 25/09/23.
//

import UIKit

extension UIImageView {
    
    /// Changing tintColor for PDF vector image
    /// - Parameter color: input UIColor
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
}
