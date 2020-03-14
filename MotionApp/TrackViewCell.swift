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
        
        label = UILabel()
        label.text = "aaaaaa"
        label.font = label.font.withSize(50)
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left)
            //            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(self.contentView.snp.height)
            //            make.center.equalTo(self.contentView.snp.center)
        }
                
    }
    
}
