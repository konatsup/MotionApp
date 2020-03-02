//
//  DrawView.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/01.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import Sica

final class DrawView: BaseView {
    
    var penColor = UIColor.black
    var penSize: CGFloat = 6.0
    private var path = UIBezierPath()
    private var drawLayer: MyShapeLayer!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        print( currentPoint)
        
        //        addRectLayer(p: currentPoint)
        //        path.move(to: currentPoint)
//        drawLayer.sica
//            .addBasicAnimation(keyPath: .positionY, from: 200, to: 600, duration: 2, timingFunction: .easeOutExpo)
//            .addBasicAnimation(keyPath: .positionX, from: 50, to: 200, duration: 2, timingFunction:  .easeOutExpo)
//            .run(type: .sequence)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let currentPoint = touches.first!.location(in: self)
        //        path.addLine(to: currentPoint)
        //        drawLayer.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        addRectLayer(p: currentPoint)
        //        path.addLine(to: currentPoint)
        //        drawLayer.path = path.cgPath
    }
    
//    private func configure() {
//        let nib = UINib(nibName: "DrawView", bundle: nil)
//        guard let view = nib.instantiate(withOwner: self, options: nil).first as? DrawView else { return }
//        view.frame = bounds
//        addSubview(view)
//        print("configure")
//    }
    
    //    func loadNib() {
    //        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
    //            view.frame = self.bounds
    //            self.addSubview(view)
    //        }
    //    }
    
    private func addRectLayerCenter() {
        drawLayer = MyShapeLayer()
        let x = bounds.width / 2
        let y = bounds.height / 2
        drawLayer.frame = CGRect(x: x, y: y, width:80, height:80)
        drawLayer.drawOval(lineWidth:1)
        layer.addSublayer(drawLayer)
    }
    
    private func addRectLayer(p currentPoint: CGPoint) {
        let drawLayer = MyShapeLayer()
        let x = currentPoint.x - 40
        let y = currentPoint.y - 40
        drawLayer.frame = CGRect(x: x, y: y, width:80, height:80)
        drawLayer.drawOval(lineWidth:1)
        layer.addSublayer(drawLayer)
    }
}
