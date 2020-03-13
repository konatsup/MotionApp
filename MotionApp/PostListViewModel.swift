//
//  PostListViewModel.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/13.
//  Copyright © 2020 konatsup. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

final class PostListViewModel {
    private let disposeBag = DisposeBag()
    
    //    var databaseRef: DatabaseReference!
    
    //input
    var btnTapped = PublishRelay<Void>()
    
    //output
    var timer: Timer = Timer()
    var timerCountRelay = PublishRelay<Double>()
    var timerCount: Double = 0.0
    
    var animationsRelay = PublishRelay<[AnimationLayer]>()
    var animations: [AnimationLayer] = []
    
    let maxRepeatTime = 10.0
    
    init() {
        //        databaseRef = Database.database().reference()
        //        btnTapped.bind(to: Binder(self) {me, _ in
        print("init PLViewModel")
        if !self.timer.isValid {
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.up), userInfo: nil,  repeats: true)
        }
        //            let opacity = 10
        //            me.e.opacity += 10
        //
        //            let position: CGPoint = CGPoint(x: 0, y: 0)
        //            me.e.position = position
        
        //            me.entityRelay.accept(me.e)
        //        }).disposed(by: disposeBag)
        
    }
    
    func initAnimations(animations: [AnimationLayer]) {
        //        print("editVC initAnimatons")
        self.animations = animations
        self.animationsRelay.accept(animations)
        print("editVC initAnimatons")
    }
    
    @objc func up() {
        if timerCount < maxRepeatTime {
            timerCount += 0.01
        } else {
            timerCount = 0
        }
        print(timerCount)
        self.timerCountRelay.accept(timerCount)
        
        
    }
    
}
