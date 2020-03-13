//
//  TrackViewCell.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/04.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

class TrackViewCell: UITableViewCell , UIScrollViewDelegate{
    @IBOutlet var label: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell() {
        self.label.text = "aaaaaa"
        //      self.scrollView = station.prefecture as String
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("endDragging")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        print("didEndDecelerating")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
    }
}
