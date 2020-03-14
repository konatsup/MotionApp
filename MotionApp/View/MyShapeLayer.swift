//
//  MyShapeLayer.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/01.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

class MyShapeLayer: CALayer {
    func drawRect(lineWidth:CGFloat){
        let rect = CAShapeLayer()
        rect.strokeColor = UIColor.black.cgColor
        rect.fillColor = UIColor.clear.cgColor
        rect.lineWidth = lineWidth
        rect.path = UIBezierPath(rect:CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height)).cgPath
        self.addSublayer(rect)
    }
    
    func drawDivisionBar(x: CGFloat, y: CGFloat, height: CGFloat, lineWidth:CGFloat){
        let rect = CAShapeLayer()
        rect.strokeColor = UIColor.black.cgColor
        rect.fillColor = UIColor.clear.cgColor
        rect.lineWidth = lineWidth
        rect.path = UIBezierPath(rect:CGRect(x: x, y: y, width: lineWidth, height: height)).cgPath
        self.addSublayer(rect)
    }
    
    func drawOval(lineWidth:CGFloat){
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = UIColor.blue.cgColor
        ovalShapeLayer.fillColor = UIColor.clear.cgColor
        ovalShapeLayer.lineWidth = lineWidth
        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:self.frame.width, height: self.frame.height)).cgPath
        self.addSublayer(ovalShapeLayer)
    }
    
}
