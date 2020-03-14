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
//    var scrollView: UIScrollView = UIScrollView()
//    var viewModel: EditViewModel = EditViewModel()
    
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
//        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 100))
//        scrollView.delegate = self
//        scrollView.backgroundColor = .blue
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
//
//        let width = self.contentView.frame.maxX
//        let pageSize = 10
//        scrollView.contentSize = CGSize(width:CGFloat(pageSize) * width, height:0)
//
//        self.contentView.addSubview(scrollView)
//
//        scrollView.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(self.contentView.snp.top)
//            make.width.equalTo(self.contentView.snp.width)
//            make.height.equalTo(self.contentView.snp.height)
//            make.center.equalTo(self.contentView.snp.center)
//        }
        
//        print(width)
//        for i in 0 ..< pageSize {
//
//            //ページごとに異なるラベルを表示.
//            let myLabel:UILabel = UILabel(frame: CGRect(x:CGFloat(i)*width/4, y:0, width:80, height:20))
//            myLabel.backgroundColor = UIColor.red
//            myLabel.textColor = UIColor.white
//            myLabel.textAlignment = NSTextAlignment.center
//            myLabel.layer.masksToBounds = true
//            myLabel.text = "Page\(i)"
//            myLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
//            myLabel.layer.cornerRadius = 30.0
//
//            scrollView.addSubview(myLabel)
//        }
        
        label = UILabel()
        //        label.text = "aaaaaa"
        label.font = label.font.withSize(50)
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left)
            //            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(self.contentView.snp.height)
            //            make.center.equalTo(self.contentView.snp.center)
        }
        
        //        scrollViewList.append(scrollView)
        
    }
    
}
