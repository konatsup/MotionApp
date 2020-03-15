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
    
    func drawDivisionBar(x: CGFloat, y: CGFloat, height: CGFloat, lineWidth:CGFloat, text: String){
        let rect = CAShapeLayer()
        rect.strokeColor = UIColor.black.cgColor
        rect.fillColor = UIColor.clear.cgColor
        rect.lineWidth = lineWidth
        rect.path = UIBezierPath(rect:CGRect(x: x, y: y, width: lineWidth, height: height)).cgPath
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x - CGFloat(10), y: y - CGFloat(20), width: 50, height: 50)
        textLayer.string = text
        textLayer.fontSize = 15
        self.addSublayer(textLayer)
        
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
    
    func drawTrack(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        let rect = CAShapeLayer()
        rect.strokeColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0).cgColor
        rect.fillColor = UIColor(red: 22/255, green: 25/255, blue: 41/255, alpha: 1.0).cgColor
        rect.lineWidth = 0.5
        rect.cornerRadius = 10
        rect.path = UIBezierPath(rect:CGRect(x: x, y: y, width: width, height: height)).cgPath
        self.addSublayer(rect)
    }
    
    
}
