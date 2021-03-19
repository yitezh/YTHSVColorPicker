//
//  XYHSVColorMediator.swift
//  XYVivaEditor
//
//  Created by yitezh on 2021/3/19.
//

import UIKit


class YTHSVColorMediator: NSObject {
    
    func getHSVColor(xrate:CGFloat,yrate:CGFloat,mainColor:UIColor) -> UIColor {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        let xrate = xrate
        let yrate = yrate
        
        let sliderRGB:(r: CGFloat,g: CGFloat,b: CGFloat) = self.getColorRBGA(color: mainColor)
        r = sliderRGB.r * yrate;
        g = sliderRGB.g * yrate;
        b = sliderRGB.b * yrate;
        
        let tempA:(r: CGFloat,g: CGFloat,b: CGFloat) = (yrate,yrate,yrate)
        let tempB:(r: CGFloat,g: CGFloat,b: CGFloat) = (r,g,b)
        
        r = tempA.r - xrate * (tempA.r - tempB.r);
        g = tempA.g - xrate * (tempA.g - tempB.g);
        b = tempA.b - xrate * (tempA.b - tempB.b);
        return UIColor.init(red: r, green: g, blue: b, alpha: 1)
        
        
    }
    
    func getHSVData(color:UIColor) -> (H: CGFloat,S: CGFloat,V: CGFloat){
        var H:CGFloat = 0
        var S:CGFloat = 0
        var V:CGFloat = 0
        var alpha:CGFloat = 0
        let isSuccess = color.getHue(&H, saturation: &S, brightness: &V, alpha: &alpha)
        
        if(!isSuccess) {
            return (0,0,0)
        }

        return (H,S,V)
    }
    
    func getHueColor(percent:CGFloat) -> UIColor {
        var percent = percent
        percent = min(percent, 1)
        percent = max(0, percent)
//        var n:(Int) = (Int)(1530 * percent);
//        var r:(Int) = 0
//        var g:(Int) = 0
//        var b:(Int) = 0
//        switch (n/255) {
//            case 0: r = 255; g = 0; b = n; break;
//            case 1: r = 255 - (n % 255); g = 0; b = 255; break;
//            case 2: r = 0; g = n % 255; b = 255; break;
//            case 3: r = 0; g = 255; b = 255 - (n % 255); break;
//            case 4: r = n % 255; g = 255; b = 0; break;
//            case 5: r = 255; g = 255 - (n % 255); b = 0; break;
//            default: r = 255; g = 0; b = 0; break;
//        }
//        var color  = UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
//        return color
        
        
        let color = UIColor.init(hue: percent, saturation: 1, brightness: 1, alpha: 1)
        return color
    }
    
    func getColorRBGA(color:UIColor?) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        guard let theColor = color else {
            return (0,0,0)
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        theColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b)
    }
    
}


