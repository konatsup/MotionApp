//
//  ViewModel.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/01.
//  Copyright © 2020 konatsup. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol ViewModelInput {
    var btnTapped: PublishRelay<Void> { get }
}

protocol ViewModelOutput {
    var entityRelay: PublishRelay<Entity> { get }
}

struct Entity {
    var opacity: Int = 0
    var position: CGPoint = CGPoint(x: 0, y: 0)
}

final class EditViewModel: ViewModelInput, ViewModelOutput {
    private let disposeBag = DisposeBag()
    
    private let timeInterval = 0.1
    
    var databaseRef: DatabaseReference!
    
    //input
    var btnTapped = PublishRelay<Void>()
    var stopBtnTapped = PublishRelay<Void>()
    var uploadBtnTapped = PublishRelay<Void>()
    var testBtnTapped = PublishRelay<Void>()
    
    //output
    var entityRelay = PublishRelay<Entity>()
    var e = Entity()
    
    var timer: Timer = Timer()
    var timerCountRelay = PublishRelay<Double>()
    var timerCount: Double = 0.0
    
    var animationsRelay = PublishRelay<[AnimationLayer]>()
    var animations: [AnimationLayer] = []
    
    var vcStateRelay = PublishRelay<String>()
    var scrollOffsetRelay = PublishRelay<CGFloat>()
//    var uploadEndRelay = PublishRelay<CGFloat>()
    
    init() {
        databaseRef = Database.database().reference()
        //        databaseRef.observe(.childAdded, with: { snapshot in
        //            if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message = obj["message"] {
        //                //                let currentText = self.textView.text
        //                //                self.textView.text = (currentText ?? "") + "\n\(name) : \(message)"
        //            }
        //        })
        
        btnTapped.bind(to: Binder(self) {me, _ in
            
            if !me.timer.isValid {
                me.timer =
                Timer.scheduledTimer(timeInterval: me.timeInterval, target: me, selector: #selector(me.up), userInfo: nil,  repeats: true)
            }
        }).disposed(by: disposeBag)
        
        stopBtnTapped.bind(to: Binder(self) {me, _ in
            
            if me.timer.isValid {
                me.timerCount = 0
                me.timer.invalidate()
            }
            //            let opacity = 10
            //            me.e.opacity += 10
            //
            //            let position: CGPoint = CGPoint(x: 0, y: 0)
            //            me.e.position = position
            
            //            me.entityRelay.accept(me.e)
        }).disposed(by: disposeBag)
        
        uploadBtnTapped.bind(to: Binder(self) {me, _ in
            print("upload")
            
            //            var animations: [AnimationLayer] = []
            //            let animation1 = AnimationLayer(startTime: 1.0, endTime: 2.0, fromX: 100, fromY: 100, toX: 300, toY: 600)
            //            let animation2 = AnimationLayer(startTime: 3.0, endTime: 5.0, fromX: 0, fromY: 800, toX: 400, toY: 200)
            //            animations.append(animation1)
            //            animations.append(animation2)
            
            var animationDictionaries: [Dictionary<String, Double>] = []
            for animation in me.animations {
                let ad = ["startTime": animation.startTime, "endTime": animation.endTime, "fromX": animation.fromX, "fromY": animation.fromY, "toX": animation.toX, "toY": animation.toY]
                animationDictionaries.append(ad)
            }
            let projectData = ["animations" : animationDictionaries]
            self.databaseRef.child("projects") .childByAutoId().setValue(projectData)
            
            me.vcStateRelay.accept("uploadEnd")
            
        }).disposed(by: disposeBag)
        
        testBtnTapped.bind(to: Binder(self) {me, _ in
            print("test")
            me.updateAnimations(animations: me.animations)
            me.vcStateRelay.accept("popViewController")
            
        }).disposed(by: disposeBag)
        
    }
    
    func updateAnimations(animations: [AnimationLayer]) {
        self.animations = animations
        self.animationsRelay.accept(animations)
    }
    
    func setTimerCount(timerCount: Double){
        self.timerCount = timerCount
        self.timerCountRelay.accept(timerCount)
    }
    
    @objc func up() {
        timerCount += self.timeInterval
        print(timerCount)
        self.timerCountRelay.accept(timerCount)
    }
    
    
}
