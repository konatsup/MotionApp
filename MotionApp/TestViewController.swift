//
//  TestViewController.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/04.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate {
    // UIPageControl.
    var pageControl: UIPageControl!
    // UIScrillView.
    var scrollViewHeader: UIScrollView!
    var scrollViewMain: UIScrollView!
    // ページ番号.
    let pageSize = 10
    
    var tableView: UITableView!
    let items = ["Apple","Banana","Orange"]

    override func viewDidLoad() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        self.tableView.allowsSelection = false
        tableView.register(UINib(nibName: "TrackViewCell", bundle: nil), forCellReuseIdentifier: "TrackViewCell")
        self.view.addSubview(tableView)
        // 画面サイズの取得.
        let width = self.view.frame.maxX, height = self.view.frame.maxY

        // ScrollViewHeaderの設定.
        scrollViewHeader = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3))
        scrollViewHeader.showsHorizontalScrollIndicator = false
        scrollViewHeader.showsVerticalScrollIndicator = false
//        scrollViewHeader.isPagingEnabled = true
        scrollViewHeader.delegate = self
        scrollViewHeader.contentSize = CGSize(width:CGFloat(pageSize) * width, height:0)
        self.view.addSubview(scrollViewHeader)

        // ScrollViewMainの設定.
//        scrollViewMain = UIScrollView(frame: self.view.frame)
//        scrollViewMain.showsHorizontalScrollIndicator = false
//        scrollViewMain.showsVerticalScrollIndicator = false
//        scrollViewMain.isPagingEnabled = true
//        scrollViewMain.delegate = self
//        scrollViewMain.contentSize = CGSize(width:CGFloat(pageSize) * width, height:0)
//        self.view.addSubview(scrollViewMain)

        // ScrollView1に貼付けるLabelの生成.
//        for i in 0 ..< pageSize {
//
//            //ページごとに異なるラベルを表示.
//            let myLabel:UILabel = UILabel(frame: CGRect(x:CGFloat(i)*width+width/2-40, y:height/2 - 40, width:80, height:80))
//            myLabel.backgroundColor = UIColor.black
//            myLabel.textColor = UIColor.white
//            myLabel.textAlignment = NSTextAlignment.center
//            myLabel.layer.masksToBounds = true
//            myLabel.text = "Page\(i)"
//            myLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
//            myLabel.layer.cornerRadius = 40.0
//
//            scrollViewMain.addSubview(myLabel)
//        }

        // ScrollView2に貼付ける Labelの生成.
        for i in 0 ..< pageSize {

            //ページごとに異なるラベルを表示.
            let myLabel:UILabel = UILabel(frame: CGRect(x:CGFloat(i)*width/4, y:50, width:80, height:60))
            myLabel.backgroundColor = UIColor.red
            myLabel.textColor = UIColor.white
            myLabel.textAlignment = NSTextAlignment.center
            myLabel.layer.masksToBounds = true
            myLabel.text = "Page\(i)"
            myLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            myLabel.layer.cornerRadius = 30.0

            scrollViewHeader.addSubview(myLabel)
        }

        // PageControlを作成.
//        pageControl = UIPageControl(frame: CGRect(x:0, y:self.view.frame.maxY - 50, width:width, height:50))
//        pageControl.backgroundColor = UIColor.lightGray
//
//        // PageControlするページ数を設定.
//        pageControl.numberOfPages = pageSize
//
//        // 現在ページを設定.
//        pageControl.currentPage = 0
//        pageControl.isUserInteractionEnabled = false
//
//        self.view.addSubview(pageControl)
    }

    /*
     ScrollViewが移動した際に呼ばれる.
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollViewMain {
//            scrollViewHeader.contentOffset.x = scrollViewMain.contentOffset.x
        }
    }

    /*
     移動が完了したら呼ばれる.
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // スクロール数が1ページ分になったら.
//        if fmod(scrollViewMain.contentOffset.x, scrollViewMain.frame.maxX) == 0 {
//            // ページの場所を切り替える.
//            pageControl.currentPage = Int(scrollViewMain.contentOffset.x / scrollViewMain.frame.maxX)
//        }
    }

}


extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "section:[\(indexPath.section)], row:[\(indexPath.row)]"
        return cell
    }
    
    //セルの数をいくつにするか。
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    
}
