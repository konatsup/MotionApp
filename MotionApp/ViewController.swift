//
//  ViewController.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/02/24.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import SnapKit
import SpreadsheetView

class ViewController: UIViewController {
    lazy var box = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(box)
        box.backgroundColor = .green
        box.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.center.equalTo(self.view)
        }
    }
    
    
}

