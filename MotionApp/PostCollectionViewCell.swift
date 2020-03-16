//
//  PostCollectionViewCell.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/13.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    var drawView: DrawView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 2.0

        drawView = DrawView()
        contentView.addSubview(drawView)
    }
    
    func setAnimations(animations: [AnimationLayer]){
        drawView.updateHalfAnimations(animations: animations)
    }
    
//    func setupContents(textName: String) {
//        fruitsNameLabel.text = textName
//    }
}
