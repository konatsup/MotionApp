//
//  BaseView.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/02.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

class BaseView: UIView {
    //コードから生成したときに通る初期化処理
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    //InterfaceBulderで配置した場合に通る初期化処理
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadNib() {
        let nib = UINib(nibName: "BaseView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }

}
