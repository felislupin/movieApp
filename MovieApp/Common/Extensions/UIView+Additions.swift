//
//  UIView+Additions.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import UIKit
import Foundation

extension UIView {

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable public var shadowCornerRadius: Float {
        get {
            return Float(layer.cornerRadius)
        }
        set {
            layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    
    @IBInspectable public var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func glow() {
        
        let anim = CASpringAnimation(keyPath: "opacity")
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        
        pulse.duration = 1.5
        anim.duration = 1.5
        
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.timingFunction = CAMediaTimingFunction(name : .easeInEaseOut)
        
        pulse.fromValue = 0.4
        anim.fromValue = 0
        
        pulse.toValue = 1
        anim.toValue = 1
        
        pulse.autoreverses = false
        anim.autoreverses = false
        
        pulse.repeatCount = 0
        anim.repeatCount = 0
        
        layer.add(anim, forKey: nil)
        layer.add(pulse, forKey: nil)
    }
    
    func shine() {
        
        let transparency = CASpringAnimation(keyPath: "opacity")
        let move = CASpringAnimation(keyPath: "position")
        
        let size = superview?.superview?.frame.size
        let from = CGPoint(x: (size?.width)! - self.frame.width, y: 0 - self.frame.height)
        let to = self.center
        
        move.duration = 5
        transparency.duration = 10
        
        transparency.timingFunction = CAMediaTimingFunction(name : .easeInEaseOut)
        move.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        move.fromValue = from
        transparency.fromValue = 0
        
        move.toValue = to
        transparency.toValue = 1
        
        move.autoreverses = false
        transparency.autoreverses = false
        
        move.repeatCount = 0
        transparency.repeatCount = 0
        
        layer.add(move, forKey: nil)
        layer.add(transparency, forKey: nil)
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


