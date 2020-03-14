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
import SpreadsheetView
//import Firebase

class EditViewController: UIViewController{
    //    var spreadsheetView: SpreadsheetView!
    
    private lazy var dataSource = EditViewDataSource()
    //        private lazy var spreadSheetView: SpreadsheetView = {
    //            let spreadSheetView = SpreadsheetView()
    //            spreadSheetView.translatesAutoresizingMaskIntoConstraints = false
    //            spreadSheetView.backgroundColor = .white
    //            spreadSheetView.dataSource = dataSource
    //            spreadSheetView.delegate = self
    //            spreadSheetView.stickyRowHeader = true
    //            spreadSheetView.stickyColumnHeader = true
    //            spreadSheetView.bounces = false
    //            spreadSheetView.isDirectionalLockEnabled = true
    //            //        spreadSheetView.gridStyle = .default
    //            spreadSheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
    //            spreadSheetView.register(TimeMeterCell.self, forCellWithReuseIdentifier: String(describing: TimeMeterCell.self))
    //            spreadSheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
    //            return spreadSheetView
    //        }()
    
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
        scrollView.delegate = self
        scrollView.backgroundColor = .blue
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        let width = self.view.frame.maxX
        let pageSize = 10
        scrollView.contentSize = CGSize(width:CGFloat(pageSize) * width, height:4000)
        
        
        return scrollView
    }()
    
    var scrollBeginingPoint: CGPoint!
    
    private let disposeBag = DisposeBag()
    lazy var label = UILabel()
    var project: Project
    
    let viewModel = EditViewModel()
    
    var scrollViews: [UIScrollView] = []
    var trackViewCells: [TrackViewCell] = []
    
    let timeMeterHeight = 50
    
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
        //        fatalError("init(coder:) has not been implemented")
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
                //                me.navigationController?.popViewController(animated: true)
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
        
        //        self.view.addSubview(spreadSheetView)
        //        spreadSheetView.snp.makeConstraints { (make) -> Void in
        //            make.bottom.equalTo(self.view.snp.bottom)
        //            make.height.equalTo(self.view.snp.height).dividedBy(2)
        //            make.width.equalTo(self.view.snp.width)
        //            make.center.equalTo(self.view.snp.center)
        //        }
        //        spreadSheetView.reloadData()
        
        
        
        drawView = DrawView()
        self.view.addSubview(drawView)
        
        drawView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
            make.center.equalTo(self.view.snp.center)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).dividedBy(2).offset(-timeMeterHeight)
            make.width.equalTo(self.view.snp.width)
            make.center.equalTo(self.view.snp.center)
        }
        
//        self.view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { (make) -> Void in
//            make.bottom.equalTo(self.view.snp.bottom)
//            make.height.equalTo(self.view.snp.height).dividedBy(2)
//            make.width.equalTo(self.view.snp.width)
//
//            make.left.equalTo(self.view.snp.left).offset(50.0)
//            make.center.equalTo(self.view.snp.center)
//        }
        
        let pageSize = 10
        let width = self.view.frame.width
        for j in 0 ..< 100 {
            for i in 0 ..< pageSize {
                //ページごとに異なるラベルを表示.
                let myLabel:UILabel = UILabel(frame: CGRect(x:CGFloat(i)*width/4, y:CGFloat(j)*50, width:80, height:50))
                myLabel.backgroundColor = UIColor.red
                myLabel.textColor = UIColor.white
                myLabel.textAlignment = NSTextAlignment.center
                myLabel.layer.masksToBounds = true
                myLabel.text = "Page\(i)"
                myLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                myLabel.layer.cornerRadius = 30.0
                
                scrollView.addSubview(myLabel)
            }
        }
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("start", for: .normal)
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(400)
            make.left.equalTo(100)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        button.rx.tap
            .bind(to: viewModel.btnTapped)
            .disposed(by: disposeBag)
        
        let stopButton = UIButton()
        stopButton.backgroundColor = .orange
        stopButton.setTitle("stop", for: .normal)
        view.addSubview(stopButton)
        
        stopButton.snp.makeConstraints { (make) in
            make.top.equalTo(400)
            make.left.equalTo(150)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        stopButton.rx.tap
            .bind(to: viewModel.stopBtnTapped)
            .disposed(by: disposeBag)
        
        
        let uploadButton = UIButton()
        uploadButton.backgroundColor = .green
        uploadButton.setTitle("upload", for: .normal)
        view.addSubview(uploadButton)
        
        uploadButton.snp.makeConstraints { (make) in
            make.top.equalTo(400)
            make.left.equalTo(0)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        uploadButton.rx.tap
            .bind(to: viewModel.uploadBtnTapped)
            .disposed(by: disposeBag)
        
        let testButton = UIButton()
        testButton.backgroundColor = .blue
        testButton.setTitle("close", for: .normal)
        view.addSubview(testButton)
        
        testButton.snp.makeConstraints { (make) in
            make.top.equalTo(400)
            make.left.equalTo(50)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        testButton.rx.tap
            .bind(to: viewModel.testBtnTapped)
            .disposed(by: disposeBag)
        
        label = UILabel()
        label.text = "テキスト"
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.top).offset(-100)
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
        return 100
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
        guard scrollView == self.scrollView else { return }
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
        if scrollBeginingPoint.y != currentPoint.y {
            self.tableView.contentOffset.y = currentPoint.y
        }

    }
}
