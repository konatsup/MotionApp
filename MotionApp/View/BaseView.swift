//
//  BaseView.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/02.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadNib() {
        let nib = UINib(nibName: "BaseView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
//        view.backgroundColor = .green
        addSubview(view)
    }

}
