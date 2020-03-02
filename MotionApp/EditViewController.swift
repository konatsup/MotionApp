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

class EditViewController: UIViewController, SpreadsheetViewDelegate,SpreadsheetViewDataSource {
//    var spreadsheetView: SpreadsheetView!
    private lazy var spreadSheetView: SpreadsheetView = {
        let spreadSheetView = SpreadsheetView()
        spreadSheetView.translatesAutoresizingMaskIntoConstraints = false
        spreadSheetView.backgroundColor = .white
        spreadSheetView.dataSource = self
        spreadSheetView.delegate = self
        spreadSheetView.stickyRowHeader = true
        spreadSheetView.stickyColumnHeader = true
//        spreadSheetView.circularScrolling = CircularScrolling.Configuration.both
        spreadSheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        spreadSheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        return spreadSheetView
    }()
    var drawView: DrawView!
    
    private let disposeBag = DisposeBag()
    lazy var label = UILabel()
    
    let viewModel = EditViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.entityRelay
            .asDriver(onErrorJustReturn: Entity())
            .drive(Binder(self) {me, entity in
                me.label.text = "\(entity.opacity)"
            })
            .disposed(by: disposeBag)
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("+", for: .normal)
        view.addSubview(button)
        
//        button.snp.makeConstraints { (make) in
//            make.top.equalTo(600)
//            make.center.equalTo(self.view.center)
//            make.width.equalTo(200)
//            make.height.equalTo(50)
//        }
//
        button.rx.tap
            .bind(to: viewModel.btnTapped)
            .disposed(by: disposeBag)
        
        label = UILabel()
        label.text = "aaaa"
        self.view.addSubview(label)
        
//        label.snp.makeConstraints { (make) in
//            make.top.equalTo(button.snp.top).offset(-100)
//            make.center.equalTo(self.view.center)
//            make.width.equalTo(100)
//            make.height.equalTo(20)
//        }
        
        
//        spreadsheetView = SpreadsheetView()
//        spreadsheetView.dataSource = self
//        spreadsheetView.backgroundColor = UIColor.red
//        spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseIdentifier)
//        spreadSheetView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        self.view.addSubview(spreadSheetView)
        spreadSheetView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
            make.width.equalTo(self.view.snp.width)
            make.center.equalTo(self.view.snp.center)
        }
        
        drawView = DrawView()
        self.view.addSubview(drawView)
        drawView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
            make.center.equalTo(self.view.snp.center)
        }
        
        
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 20
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 40
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 80
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 40
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case 0 = indexPath.row {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = "aaaa"
            cell.sortArrow.text = "uuuuu"
            
            cell.setNeedsLayout()
            
            return cell
        } else {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text = "iiiiadsfafsfsdfas"
            return cell
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    
}

