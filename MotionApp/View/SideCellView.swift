//
//  SideCellView.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/02.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

final class SideCellView: BaseView {
    private var path = UIBezierPath()
    private var drawLayer: MyShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        print(frame)
        addRectLayerCenter()
//        addBackgroundLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("sideCell touched")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func addBackgroundLayer() {
        drawLayer = MyShapeLayer()
//        let x = bounds.width / 2
//        let y = bounds.height / 2
//        let x: CGFloat = 0
//        let y = 0
        drawLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        drawLayer.backgroundColor = UIColor.green.cgColor
        drawLayer.drawOval(lineWidth:1)
        layer.addSublayer(drawLayer)
    }
    
    func addRectLayerCenter() {
        drawLayer = MyShapeLayer()
        let x = bounds.width / 2
        let y = bounds.height / 2
        drawLayer.frame = CGRect(x: x, y: y, width:10, height:10)
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
