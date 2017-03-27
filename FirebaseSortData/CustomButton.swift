//
//  CustomButton.swift
//  FerebaseSortData
//
//  Created by Andrew Foster on 2/6/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        
        self.layer.cornerRadius = cornerRadius
        
    }
}
