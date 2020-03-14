//
//  ViewController.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/02/24.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class EditViewController: UIViewController{
    private lazy var dataSource = EditViewDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        tableView.allowsSelection = true
        //        tableView.isEditing = true
        //        tableView.allowsSelectionDuringEditing = false
        tableView.register(UINib(nibName: "TrackViewCell", bundle: nil), forCellReuseIdentifier: "TrackViewCell")
        return tableView
    }()
    
    var drawView: DrawView!
    
    private lazy var timeMeterView: UIScrollView = {
        let timeMeterView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.timeMeterHeight))
        timeMeterView.delegate = self
        timeMeterView.backgroundColor = .lightGray
        timeMeterView.showsHorizontalScrollIndicator = false
        timeMeterView.showsVerticalScrollIndicator = false
        timeMeterView.isDirectionalLockEnabled = true
        let width = self.view.frame.maxX
        timeMeterView.contentSize = CGSize(width:CGFloat(self.pageSize) * width, height: self.timeMeterHeight)
        
        return timeMeterView
    }()
    
    private lazy var scrollViewMain: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
        scrollView.delegate = self
        scrollView.backgroundColor = .blue
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        let width = self.view.frame.maxX
        scrollView.contentSize = CGSize(width:CGFloat(self.pageSize) * width, height:4000)
        
        return scrollView
    }()
    
    var scrollBeginingPoint: CGPoint!
    
    private let disposeBag = DisposeBag()
    lazy var label = UILabel()
    var project: Project
    
    let viewModel = EditViewModel()
    
    var scrollViews: [UIScrollView] = []
    var trackViewCells: [TrackViewCell] = []
    
    let timeMeterHeight: CGFloat = 50
    let buttonHeight = 50
    let buttonWidth = 80
    let pageSize = 10
    let sideCellWidth: CGFloat = 50.0
    
    
    init(project: Project) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        var animations: [AnimationLayer] = []
        let animation1 = AnimationLayer(startTime: 1.0, endTime: 2.0, fromX: 100, fromY: 100, toX: 300, toY: 600)
        let animation2 = AnimationLayer(startTime: 3.0, endTime: 5.0, fromX: 0, fromY: 800, toX: 400, toY: 200)
        animations.append(animation1)
        animations.append(animation2)
        let p = Project(animations: animations)
        self.project = p
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //        viewModel.entityRelay
        //            .asDriver(onErrorJustReturn: Entity())
        //            .drive(Binder(self) {me, entity in
        //                me.label.text = "\(entity.opacity)"
        //            })
        //            .disposed(by: disposeBag)
        
        viewModel.timerCountRelay
            .asDriver(onErrorJustReturn: 0)
            .drive(Binder(self) {me, timerCount in
                
                me.label.text = "\(timerCount)"
                me.drawView.update(timerCount)
            })
            .disposed(by: disposeBag)
        
        viewModel.animationsRelay
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) {me, animations in
                me.drawView.updateAnimations(animations: animations)
            })
            .disposed(by: disposeBag)
        
        viewModel.vcStateRelay
            .asDriver(onErrorJustReturn: "")
            .drive(Binder(self) {me, state in
                print(state)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.scrollOffsetRelay
            .asDriver(onErrorJustReturn: 0.0)
            .drive(Binder(self) {me, offsetX in
                for cell in me.trackViewCells {
                    //                    cell.scrollView.contentOffset.x = offsetX
                    //                    cell.setScrollOffset(offsetX: offsetX)
                }
            })
            .disposed(by: disposeBag)
        
        drawView = DrawView()
        self.view.addSubview(drawView)
        
        drawView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).dividedBy(2).offset(-timeMeterHeight)
            make.width.equalTo(self.view.snp.width)
        }
        
        self.view.addSubview(scrollViewMain)
        scrollViewMain.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(drawView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).dividedBy(2).offset(-timeMeterHeight)
            make.width.equalTo(self.view.snp.width)
            make.left.equalTo(self.view.snp.left).offset(sideCellWidth)
        }
        
        self.view.addSubview(timeMeterView)
        timeMeterView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(scrollViewMain.snp.top)
            make.height.equalTo(self.timeMeterHeight)
            make.width.equalTo(self.view.snp.width)
            make.left.equalTo(self.view.snp.left).offset(sideCellWidth)
        }
        
        let width = self.view.frame.width
        for j in 0 ..< 20 {
            for i in 0 ..< self.pageSize {
                //ページごとに異なるラベルを表示.
                let myLabel:UILabel = UILabel(frame: CGRect(x:CGFloat(i)*width/4, y:CGFloat(j)*50, width:80, height:50))
                myLabel.backgroundColor = UIColor.red
                myLabel.textColor = UIColor.white
                myLabel.textAlignment = NSTextAlignment.center
                myLabel.layer.masksToBounds = true
                myLabel.text = "Page\(j) : \(i)"
                myLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                myLabel.layer.cornerRadius = 30.0
                
                scrollViewMain.addSubview(myLabel)
            }
        }
        
        for i in 0 ..< self.pageSize {
            //ページごとに異なるラベルを表示.
            let myLabel:UILabel = UILabel(frame: CGRect(x:CGFloat(i)*width/4, y: 0, width:80, height: timeMeterHeight))
            myLabel.backgroundColor = UIColor.yellow
            myLabel.textColor = UIColor.white
            myLabel.textAlignment = NSTextAlignment.center
            myLabel.layer.masksToBounds = true
            myLabel.text = "Page\(i)"
            myLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            myLabel.layer.cornerRadius = 30.0
            
            timeMeterView.addSubview(myLabel)
        }
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("start", for: .normal)
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(self.drawView.snp.bottom).offset(-buttonHeight)
            make.left.equalTo(buttonWidth * 2)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        button.rx.tap
            .bind(to: viewModel.btnTapped)
            .disposed(by: disposeBag)
        //
        let stopButton = UIButton()
        stopButton.backgroundColor = .orange
        stopButton.setTitle("stop", for: .normal)
        view.addSubview(stopButton)
        
        stopButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.drawView.snp.bottom)
            make.left.equalTo(buttonWidth * 3)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        stopButton.rx.tap
            .bind(to: viewModel.stopBtnTapped)
            .disposed(by: disposeBag)
        
        
        let uploadButton = UIButton()
        uploadButton.backgroundColor = .green
        uploadButton.setTitle("upload", for: .normal)
        view.addSubview(uploadButton)
        
        uploadButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.drawView.snp.bottom)
            make.left.equalTo(buttonWidth * 0)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        uploadButton.rx.tap
            .bind(to: viewModel.uploadBtnTapped)
            .disposed(by: disposeBag)
        
        let testButton = UIButton()
        testButton.backgroundColor = .blue
        testButton.setTitle("close", for: .normal)
        view.addSubview(testButton)
        
        testButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.drawView.snp.bottom)
            make.left.equalTo(buttonWidth * 1)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        testButton.rx.tap
            .bind(to: viewModel.testBtnTapped)
            .disposed(by: disposeBag)
        
        label = UILabel()
        label.text = "テキスト"
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.center.equalTo(self.view.center)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        let animations = self.project.animations
        viewModel.initAnimations(animations: animations)
        
    }
    
}

//extension EditViewController: UITableViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("DAAAAAAAA")
//        return
//    }



//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//}

extension EditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackViewCell") as! TrackViewCell
        
        cell.label.text = "\(indexPath.item)"
        cell.backgroundColor = .green
        //                cell.textLabel?.text = "section:[\(indexPath.section)], row:[\(indexPath.row)]"
        //        scrollViews.append(cell.scrollView)
        //        cell.viewModel = self.viewModel
        //        trackViewCells.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // TODO: 入れ替え時の処理を実装する（データ制御など）
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //        scrollBeginingPoint = scrollView.contentOffset;
    //    }
    //
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        let currentPoint = scrollView.contentOffset
    //        print(currentPoint)
    //        if scrollBeginingPoint.y != currentPoint.y {
    //            self.scrollView.contentOffset.y = currentPoint.y
    //        }
    //    }
    
    
    //    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    //
    //        if indexPath.row == 3 {
    //            return nil
    //        }
    //        return indexPath
    //    }
}


extension EditViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("endDragging")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        guard scrollView == self.scrollView else { return }
        print("didEndDecelerating")
    }
    //
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginingPoint = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        //        print(scrollView.contentOffset)
        let currentPoint = scrollView.contentOffset
        
        if scrollView == timeMeterView {
            if scrollBeginingPoint.x != currentPoint.x {
                self.scrollViewMain.contentOffset.x = currentPoint.x
            }
        } else if scrollView == scrollViewMain {
            if scrollBeginingPoint.y != currentPoint.y {
                self.tableView.contentOffset.y = currentPoint.y
            } else if scrollBeginingPoint.x != currentPoint.x {
                self.timeMeterView.contentOffset.x = currentPoint.x
            }
        }
        
    }
}
