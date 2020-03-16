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
import Floaty

class EditViewController: UIViewController{
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .darkGray
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        //        tableView.isEditing = true
        //        tableView.allowsSelectionDuringEditing = false
        tableView.register(UINib(nibName: "TrackViewCell", bundle: nil), forCellReuseIdentifier: "TrackViewCell")
        return tableView
    }()
    
    private lazy var timeMeterView: UIScrollView = {
        let timeMeterView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.timeMeterHeight))
        timeMeterView.delegate = self
        timeMeterView.backgroundColor = UIColor.whiteColor()
        timeMeterView.showsHorizontalScrollIndicator = false
        timeMeterView.showsVerticalScrollIndicator = false
        timeMeterView.isDirectionalLockEnabled = true
        //        let width = self.view.frame.maxX
        timeMeterView.contentSize = CGSize(width: CGFloat(self.maxDuration) * self.divisionWidth + self.trackMarginRight + self.trackMarginLeft, height: self.timeMeterHeight)
        
        return timeMeterView
    }()
    
    private lazy var scrollViewMain: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        let width = self.view.frame.maxX
        scrollView.contentSize = CGSize(width:CGFloat(self.maxDuration) * self.divisionWidth + self.trackMarginRight + self.trackMarginLeft, height: CGFloat(self.project.animations.count + 1) * self.trackHeight)
        
        return scrollView
    }()
    
    
    var drawView: DrawView!
    var barView: UIView!
    
    var scrollBeginingPoint: CGPoint!
    var currentTimePosition: CGFloat = 0.0
    
    private let disposeBag = DisposeBag()
    lazy var label = UILabel()
    var project: Project
    
    let viewModel = EditViewModel()
    
    var scrollViews: [UIScrollView] = []
    var trackViewCells: [TrackViewCell] = []
    let timeMeterLayer = MyShapeLayer()
    let trackLayer = MyShapeLayer()
    let barLayer = MyShapeLayer()
    
    let timeMeterHeight: CGFloat = 50
    let buttonHeight = 50
    var buttonWidth: CGFloat = 0
    let maxDuration: CGFloat = 200
    let sideCellWidth: CGFloat = 50.0
    let divisionWidth: CGFloat = 10
    let divisionNumPerSec: CGFloat = 10
    let trackHeight: CGFloat = 50
    var trackMarginLeft: CGFloat = 0
    let trackMarginRight: CGFloat = 50
    let barWidth: CGFloat = 5

    init(project: Project) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        var animations: [AnimationLayer] = []
        let animation1 = AnimationLayer(startTime: 1.0, endTime: 1.5, fromX: 0, fromY: 100, toX: 300, toY: 200)
        let animation2 = AnimationLayer(startTime: 3.0, endTime: 4.0, fromX: 200, fromY: 200, toX: 20, toY: 100)
        animations.append(animation1)
        animations.append(animation2)
        let p = Project(animations: animations)
        self.project = p
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.width
        view.backgroundColor = .white
        
        buttonWidth = view.frame.width / 5
        trackMarginLeft = view.frame.width / 2 - sideCellWidth
        
        viewModel.timerCountRelay
            .asDriver(onErrorJustReturn: 0)
            .drive(Binder(self) {me, timerCount in
                
                me.label.text = NSString(format: "%.1f", timerCount ) as String
                me.drawView.update(timerCount)
                let currentPositionX = CGFloat(timerCount) * self.divisionWidth * self.divisionNumPerSec
                me.timeMeterView.contentOffset.x = currentPositionX
                
            })
            .disposed(by: disposeBag)
        
        viewModel.animationsRelay
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) {me, animations in
                me.self.renderTrack()
                me.drawView.updateAnimations(animations: animations)
                
                me.tableView.reloadData()
                me.scrollViewMain.contentSize = CGSize(width:CGFloat(self.maxDuration) * self.divisionWidth + self.trackMarginRight + self.trackMarginLeft, height: CGFloat(self.project.animations.count + 1) * self.trackHeight)
            })
            .disposed(by: disposeBag)
        
        viewModel.vcStateRelay
            .asDriver(onErrorJustReturn: "")
            .drive(Binder(self) {me, state in
                print(state)
                
                
                switch state {
                case "popViewController":
                    me.dismiss(animated: true, completion: nil)
                case "uploadEnd":
                    let alert = UIAlertController(title: "投稿が完了しました", message: nil, preferredStyle: .alert)
                    let yesAction : UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                        action in
                        
                        //                        let ChatController = chatController()
                        //                        self.present(UINavigationController(rootViewController: ChatController),animated: true , completion: nil)
                        me.dismiss(animated: true, completion: nil)
                        print("adafdasfs")
                    }
                    alert.addAction(yesAction)
                    me.present(alert, animated: true, completion: nil)
                    
                default:
                    print("default")
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
        
        barView = UIView()
        barView.frame = CGRect(x: 0, y: 0, width: barWidth, height: height)
        self.view.addSubview(barView)
        barView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
        }
        
        
        scrollViewMain.layer.addSublayer(trackLayer)
        
        timeMeterLayer.frame = CGRect(x: 0, y: 0, width: divisionWidth * maxDuration + trackMarginLeft, height: timeMeterHeight)
        timeMeterView.layer.addSublayer(timeMeterLayer)
        
        
        barLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        barView.layer.addSublayer(barLayer)
        
        
        for i in 0 ..< Int(self.maxDuration) {
            
            let index = CGFloat(i)
            let x = index * divisionWidth + self.trackMarginLeft
            var y: CGFloat = 0
            var height: CGFloat = 0
            var lineWidth: CGFloat = 1
            var text: String = ""
            switch (index.truncatingRemainder(dividingBy: divisionNumPerSec)) {
            case 0:
                y = 20
                lineWidth = 2
                text = NSString(format: "%.1f", (index / divisionNumPerSec) ) as String
            case 5*(divisionNumPerSec/10):
                y = 25
                lineWidth = 1.5
            default:
                y = 40
                lineWidth = 1
            }
            height = timeMeterHeight - y
            timeMeterLayer.drawDivisionBar(x: x, y: y, height: height, lineWidth: lineWidth, text: text)
            
        }
        
        barLayer.drawMainBar(x: width/2, y: height, height: height, lineWidth: barWidth)
        
        
        let floaty = Floaty()
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor.whiteColor()
        floaty.plusColor = UIColor.blackColor()
        view.addSubview(floaty)
        
        let startButton = UIButton()
        startButton.backgroundColor = .red
        startButton.setTitle("start", for: .normal)
        view.addSubview(startButton)
        
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.drawView.snp.bottom).offset(-buttonHeight)
            make.left.equalTo(buttonWidth * 2)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        startButton.rx.tap
            .bind(to: viewModel.btnTapped)
            .disposed(by: disposeBag)
        
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
        
        let resetButton = UIButton()
        resetButton.backgroundColor = .purple
        resetButton.setTitle("reset", for: .normal)
        view.addSubview(resetButton)
        
        resetButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.drawView.snp.bottom)
            make.left.equalTo(buttonWidth * 4)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        resetButton.rx.tap
            .bind(to: viewModel.resetBtnTapped)
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
        label.text = ""
        label.textAlignment = .center
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.drawView.snp.bottom).offset(-buttonHeight)
            make.center.equalTo(self.view.center)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        let animations = self.project.animations
        viewModel.updateAnimations(animations: animations)
        
        //        rend
    }
    
    func renderTrack(){
        for i in 0 ..< self.project.animations.count {
            print(String(i))
            let animation = self.project.animations[i]
            let index = CGFloat(i)
            let x: CGFloat = divisionWidth * CGFloat(animation.startTime) * divisionNumPerSec + trackMarginLeft
            let y: CGFloat = index * trackHeight
            
            let duration = animation.endTime - animation.startTime
            let width: CGFloat = divisionWidth * CGFloat(duration) * divisionNumPerSec
            let height: CGFloat = trackHeight
            trackLayer.drawTrack(x: x, y: y, width: width, height: height)
        }
    }
    
    
}

extension EditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackViewCell") as! TrackViewCell
        
        cell.label.text = "\(indexPath.item)"
        cell.backgroundColor = .darkGray
        //                cell.textLabel?.text = "section:[\(indexPath.section)], row:[\(indexPath.row)]"
        //        scrollViews.append(cell.scrollView)
        //        cell.viewModel = self.viewModel
        //        trackViewCells.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.project.animations.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)番目の行が選択されました。")
        
        
    }
    
}


extension EditViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("endDragging")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("didEndDecelerating")
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        scrollBeginingPoint = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("scrollViewDidScroll")
        let currentPoint = scrollView.contentOffset
        
        if scrollView == timeMeterView {
//            print(currentPoint.x)
            self.scrollViewMain.contentOffset.x = currentPoint.x
            let timerCount: Double = Double(currentPoint.x / (self.divisionWidth * divisionNumPerSec))
            viewModel.setTimerCount(timerCount: timerCount)
        } else if scrollView == scrollViewMain {
//            print("main: \(currentPoint.x)")
            self.tableView.contentOffset.y = currentPoint.y
            self.timeMeterView.contentOffset.x = currentPoint.x
        }
        
    }
}


extension EditViewController: FloatyDelegate {
    func emptyFloatySelected(_ floaty: Floaty) {
        let animation = AnimationLayer(startTime: 2.0, endTime: 3.0, fromX: 0, fromY: 200, toX: 300, toY: 200)
        self.project.animations.append(animation)
        self.viewModel.updateAnimations(animations: self.project.animations)
        
        //        let alert = UIAlertController(title: "FABが押されました", message: nil, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //        present(alert, animated: true, completion: nil)
    }
}
