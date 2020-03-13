//
//  TimeMeterView.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/02.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import Sica

final class TimeMeterView: UIView {
    
    private var path = UIBezierPath()
    private var drawLayer: MyShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        //        initDrawLayer()
//                subviews.map{ $0.backgroundColor = .green }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadNib() {
        let nib = UINib(nibName: "BaseView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
//        view.backgroundColor = .blue
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func initDrawLayer() {
        drawLayer = MyShapeLayer()
        let x: CGFloat = 0
        let y: CGFloat = 0
        //        drawLayer.backgroundColor = UIColor.blue.cgColor
        drawLayer.frame = CGRect(x: x, y: y, width: 100, height: 100)
        drawLayer.drawRect(lineWidth:1)
        layer.addSublayer(drawLayer)
    }
    
    func setBackgroundGreen(){
        subviews.map{ $0.backgroundColor = .green }
        
    }
    
}
