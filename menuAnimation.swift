//
//  menuAnimation.swift
//  InstantCook
//
//  Created by Gizem Dal on 4/3/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit

class menuAnimation: UIView {
    
    func slideFront(x: Int, view: menuAnimation) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.5
        animation.repeatCount = 1
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(x), y: self.center.y))
        self.layer.position = CGPoint(x: CGFloat(x), y: self.center.y)
        self.layer.add(animation, forKey: "position")
    }
    
    func slideBack(x: Int, view: menuAnimation) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.5
        animation.repeatCount = 1
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(x), y: self.center.y))
        self.layer.position = CGPoint(x: CGFloat(x), y: self.center.y)
        self.layer.add(animation, forKey: "position")
    }
}
