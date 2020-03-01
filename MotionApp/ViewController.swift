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

class ViewController: UIViewController, SpreadsheetViewDataSource {
    lazy var box = UIView()
    var spreadsheetView: SpreadsheetView!
    var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        spreadsheetView = SpreadsheetView()
//        spreadsheetView.dataSource = self
//        spreadsheetView.backgroundColor = UIColor.red
//        spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseIdentifier)
//        spreadSheetView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
//        self.view.addSubview(spreadsheetView
//        spreadsheetView.snp.makeConstraints { (make) -> Void in
//            make.width.height.equalTo(100)
//            make.center.equalTo(self.view)
//        }
        
//        let oval = MyShapeLayer()
//        oval.frame = CGRect(x:30,y:30,width:80,height:80)
//        oval.drawOval(lineWidth:1)
//        self.view.layer.addSublayer(oval)
//
//        let rect = MyShapeLayer()
//        rect.frame = CGRect(x:40,y:40,width:50,height:50)
//        rect.drawRect(lineWidth:1)
//        self.view.layer.addSublayer(rect)
        
        drawView = DrawView()
//        drawView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2)
//        drawView.backgroundColor = .red
        self.view.addSubview(drawView)
        drawView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
            make.center.equalTo(self.view.snp.center)
        }
//
//                box.backgroundColor = .green
        // Do any additional setup after loading the view.
//        self.view.addSubview(box)
//        box.backgroundColor = .green
//        box.snp.makeConstraints { (make) -> Void in
//            make.width.height.equalTo(50)
//            make.center.equalTo(self.view)
//        }
        
        
        
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 200
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 400
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 80
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 40
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case 0 = indexPath.row {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = "aaaa"
            
            
            cell.sortArrow.text = "uuuuu"
            
            cell.setNeedsLayout()
            
            return cell
        } else {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text = "iiii"
            return cell
        }
    }
    
    
}

