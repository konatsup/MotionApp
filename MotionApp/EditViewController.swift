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

class EditViewController: UIViewController, SpreadsheetViewDelegate{
    //    var spreadsheetView: SpreadsheetView!
    
    private lazy var dataSource = EditViewDataSource()
    private lazy var spreadSheetView: SpreadsheetView = {
        let spreadSheetView = SpreadsheetView()
        spreadSheetView.translatesAutoresizingMaskIntoConstraints = false
        spreadSheetView.backgroundColor = .white
        spreadSheetView.dataSource = dataSource
        spreadSheetView.delegate = self
        spreadSheetView.stickyRowHeader = true
        spreadSheetView.stickyColumnHeader = true
        spreadSheetView.bounces = false
        spreadSheetView.isDirectionalLockEnabled = true
        //        spreadSheetView.gridStyle = .default
        spreadSheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        spreadSheetView.register(TimeMeterCell.self, forCellWithReuseIdentifier: String(describing: TimeMeterCell.self))
        spreadSheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        return spreadSheetView
    }()
    
    
    var drawView: DrawView!
    
    private let disposeBag = DisposeBag()
    lazy var label = UILabel()
    var project: Project
    
    let viewModel = EditViewModel()
    
    init(project: Project) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //        self.view.addSubview(spreadSheetView)
        //        spreadSheetView.snp.makeConstraints { (make) -> Void in
        //            make.bottom.equalTo(self.view.snp.bottom)
        //            make.height.equalTo(self.view.snp.height).dividedBy(2)
        //            make.width.equalTo(self.view.snp.width)
        //            make.center.equalTo(self.view.snp.center)
        //        }
        //        spreadSheetView.reloadData()
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("start", for: .normal)
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(600)
            make.center.equalTo(self.view.center)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button.rx.tap
            .bind(to: viewModel.btnTapped)
            .disposed(by: disposeBag)
        
        let uploadButton = UIButton()
        uploadButton.backgroundColor = .green
        uploadButton.setTitle("upload", for: .normal)
        view.addSubview(uploadButton)
        
        uploadButton.snp.makeConstraints { (make) in
            make.top.equalTo(700)
            make.center.equalTo(self.view.center)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        uploadButton.rx.tap
            .bind(to: viewModel.uploadBtnTapped)
            .disposed(by: disposeBag)
        
        let testButton = UIButton()
        testButton.backgroundColor = .blue
        testButton.setTitle("test", for: .normal)
        view.addSubview(testButton)
        
        testButton.snp.makeConstraints { (make) in
            make.top.equalTo(800)
            make.center.equalTo(self.view.center)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        testButton.rx.tap
            .bind(to: viewModel.testBtnTapped)
            .disposed(by: disposeBag)
        
        //
        label = UILabel()
        label.text = "テキスト"
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.top).offset(-100)
            make.center.equalTo(self.view.center)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        drawView = DrawView()
        self.view.addSubview(drawView)
        
        drawView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
            make.center.equalTo(self.view.snp.center)
        }
        
//        var animations: [AnimationLayer] = []
//        let animation1 = AnimationLayer(startTime: 1.0, endTime: 2.0, fromX: 100, fromY: 100, toX: 300, toY: 600)
//        let animation2 = AnimationLayer(startTime: 3.0, endTime: 5.0, fromX: 0, fromY: 800, toX: 400, toY: 200)
//        animations.append(animation1)
//        animations.append(animation2)
        
        let animations = self.project.animations
        viewModel.initAnimations(animations: animations)
                
    }
    
}

