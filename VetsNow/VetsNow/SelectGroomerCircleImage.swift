//
//  SelectGroomerCircleImage.swift
//  VetsNow
//
//  Created by Olamide Olatunji on 10/11/16.
//  Copyright © 2016 Miles Fishman. All rights reserved.
//

import UIKit

@IBDesignable class CircleImageView: UIImageView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    
    @IBInspectable var isCircle: Bool = true
    
    override func prepareForInterfaceBuilder() {
        updateView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    private func updateView() {
        
        layer.borderColor = self.borderColor.cgColor
        layer.borderWidth = borderWidth
        
        if isCircle {
            let width = self.frame.width
            layer.cornerRadius = width/2
        }
            
        else {
            layer.cornerRadius = 0
        }
    }
    
}
