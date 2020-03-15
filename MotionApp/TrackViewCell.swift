//
//  TrackViewCell.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/04.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import SnapKit

class TrackViewCell: UITableViewCell, UIScrollViewDelegate {
    var label: UILabel = UILabel()
//    var uiView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell() {
//        self.contentView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 50)
//        let uiView = UIView()
//        label = UILabel()
        label.text = "0"
        label.font = label.font.withSize(41.5)
        label.textAlignment = .center
        label.textColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
//        label.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left)
            //            make.width.equalTo(self.contentView.snp.width)
            
            make.height.equalTo(self.contentView.snp.height)
            //            make.center.equalTo(self.contentView.snp.center)
        }
                
    }
    
}
