//
//  Cells.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/01.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import SpreadsheetView

class HeaderCell: Cell {
    let label = UILabel()
    let sortArrow = UILabel()
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 2
        contentView.addSubview(label)
        
        //        sortArrow.text = ""
        //        sortArrow.font = UIFont.boldSystemFont(ofSize: 14)
        //        sortArrow.textAlignment = .center
        //        contentView.addSubview(sortArrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        sortArrow.sizeToFit()
    //        sortArrow.frame.origin.x = frame.width - sortArrow.frame.width - 8
    //        sortArrow.frame.origin.y = (frame.height - sortArrow.frame.height) / 2
    //    }
}

extension HeaderCell {
    private enum Const {
        static let margin: CGFloat = 2.0
        static let separator: CGFloat = 1.0
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class TextCell: Cell {
    let label = UILabel()
    let sideCellView = SideCellView()
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
        selectedBackgroundView = backgroundView
        
//        sideCellView.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
//              sideCellView.backgroundColor = .green
//        print(sideCellView.frame)
//        contentView.addSubview(sideCellView)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
//
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addSideCellView(width: CGFloat, height: CGFloat){
         sideCellView.frame = CGRect(x: 0, y: 0, width: width, height: height)
          sideCellView.backgroundColor = .green
        //        print(sideCellView.frame)
        contentView.addSubview(sideCellView)
    }
}
