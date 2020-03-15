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
        let rectLayer = CAShapeLayer()
        rectLayer.strokeColor = UIColor.blackColor().cgColor
        rectLayer.fillColor = UIColor.clear.cgColor
        rectLayer.lineWidth = lineWidth
        rectLayer.path = UIBezierPath(rect:CGRect(x: x, y: y, width: lineWidth, height: height)).cgPath
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x - CGFloat(10), y: y - CGFloat(20), width: 50, height: 50)
        textLayer.string = text
        textLayer.fontSize = 15
        textLayer.foregroundColor = UIColor.blackColor().cgColor
        self.addSublayer(rectLayer)
        self.addSublayer(textLayer)
    }
    
    func drawMainBar(x: CGFloat, y: CGFloat, height: CGFloat, lineWidth:CGFloat){
        let rectLayer = CAShapeLayer()
        rectLayer.strokeColor = UIColor.whiteColor().cgColor
        rectLayer.fillColor = UIColor.blueColor().cgColor
        rectLayer.lineWidth = 1
        rectLayer.path = UIBezierPath(rect:CGRect(x: x - lineWidth/2, y: 30, width: lineWidth, height: self.frame.height)).cgPath
        self.addSublayer(rectLayer)
//        let ovalShapeLayer = CAShapeLayer()
//        ovalShapeLayer.strokeColor = UIColor.blue.cgColor
//        ovalShapeLayer.fillColor = UIColor.clear.cgColor
//        ovalShapeLayer.lineWidth = lineWidth
//        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:self.frame.width, height: self.frame.height)).cgPath
//        self.addSublayer(ovalShapeLayer)
        
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
        rect.strokeColor = UIColor.blackColor().cgColor
        rect.fillColor = UIColor.blueColor().cgColor
        rect.lineWidth = 1
        rect.cornerRadius = 10
        rect.path = UIBezierPath(rect:CGRect(x: x, y: y, width: width, height: height)).cgPath
        self.addSublayer(rect)
    }
    
}
