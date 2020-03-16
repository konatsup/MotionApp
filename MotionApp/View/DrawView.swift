//
//  DrawView.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/01.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import Sica
class AnimationLayer {
    var startTime: Double
    var endTime: Double
    var fromX: Double
    var fromY: Double
    var toX: Double
    var toY: Double
    init(startTime: Double, endTime: Double, fromX: Double, fromY: Double, toX: Double, toY: Double) {
        self.startTime = startTime
        self.endTime = endTime
        self.fromX = fromX
        self.fromY = fromY
        self.toX = toX
        self.toY = toY
    }
    
    init(dict: [String: Any]) {
        self.startTime = dict["startTime"] as! Double
        self.endTime = dict["endTime"] as! Double
        self.fromX = dict["fromX"] as! Double
        self.fromY = dict["fromY"] as! Double
        self.toX = dict["toX"] as! Double
        self.toY = dict["toY"] as! Double
    }
}


final class DrawView: UIView {
    
    private var path = UIBezierPath()
    private var drawLayer: MyShapeLayer!
    private var animations: [AnimationLayer] = []
    private var drawLayers: [MyShapeLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        addSubview(view)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //
    func loadNib() {
        let nib = UINib(nibName: "BaseView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    func updateAnimations(animations: [AnimationLayer]){
        self.animations = animations
        
        layer.sublayers = layer.sublayers?.filter { theLayer in
            !theLayer.isKind(of: MyShapeLayer.classForCoder())
        }
        drawLayers.removeAll()
        
        for animation in animations {
            addRectLayer(p: CGPoint(x: animation.fromX, y: animation.fromY) )
        }
        
    }
    
//    func onUpdatedCurrentPostition(currentPosition: CGPoint) {
//        for i in 0..<animations.count {
//            let animation = animations[i]
//            let drawLayer = drawLayers[i]
//            drawLayer.position = CGPoint(x: animation.fromX, y: animation.fromY)
//        }
//    }
    
    func update(_ timerCount: Double){
        
        for i in 0..<animations.count {
            let animation = animations[i]
            let drawLayer = drawLayers[i]
            
            if timerCount < animation.startTime + 0.001 && timerCount > animation.startTime - 0.001  {
                let duration: Double = animation.endTime - animation.startTime
                
                print("duration: \(duration)")
                drawLayer.sica
                    .addBasicAnimation(keyPath: .positionX, from: CGFloat(animation.fromX), to: CGFloat(animation.toX), duration: duration, timingFunction: .easeOutExpo)
                    .run(type: .sequence)
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        //        print( currentPoint)
        
        //        addRectLayer(p: currentPoint)
        //        path.move(to: currentPoint)
        //        drawLayer.sica
        //            .addBasicAnimation(keyPath: .positionY, from: 200, to: 600, duration: 2, timingFunction: .easeOutExpo)
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
        //        drawLayer.
        drawLayer.drawOval(lineWidth:1)
        drawLayers.append(drawLayer)
        layer.addSublayer(drawLayer)
    }
}
