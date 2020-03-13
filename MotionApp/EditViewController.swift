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
    
    let viewModel = EditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        viewModel.entityRelay
        //            .asDriver(onErrorJustReturn: Entity())
        //            .drive(Binder(self) {me, entity in
        //                me.label.text = "\(entity.opacity)"
        //            })
        //            .disposed(by: disposeBag)
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("+", for: .normal)
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
        
        
        
        //
        label = UILabel()
        label.text = "aaaa"
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.top).offset(-100)
            make.center.equalTo(self.view.center)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        //        self.view.addSubview(spreadSheetView)
        //        spreadSheetView.snp.makeConstraints { (make) -> Void in
        //            make.bottom.equalTo(self.view.snp.bottom)
        //            make.height.equalTo(self.view.snp.height).dividedBy(2)
        //            make.width.equalTo(self.view.snp.width)
        //            make.center.equalTo(self.view.snp.center)
        //        }
        //        spreadSheetView.reloadData()
        
        drawView = DrawView()
        //        print("\(self.width) : \(self.height)")
        //        drawView = DrawView(frame: CGRect(x: 0, y: 0, width: self.view.widt, height: self.height))
        self.view.addSubview(drawView)
        
        drawView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
            make.center.equalTo(self.view.snp.center)
        }
        
        
        viewModel.timerCountRelay
        .asDriver(onErrorJustReturn: 0)
        .drive(Binder(self) {me, timerCount in
            
            me.label.text = "\(timerCount)"
            me.drawView.update(timerCount)
        })
        .disposed(by: disposeBag)
        
        //        countBtn.rx.tap.bind(to: viewModel.btnTapped).disposed(by: disposeBag)
        
        
        
        
    }
    
}

