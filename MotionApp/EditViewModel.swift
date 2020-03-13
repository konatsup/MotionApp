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
    
    var databaseRef: DatabaseReference!
    
    //input
    var btnTapped = PublishRelay<Void>()
    var uploadBtnTapped = PublishRelay<Void>()
    
    //output
    var entityRelay = PublishRelay<Entity>()
    var e = Entity()
    
    var timer: Timer = Timer()
    var timerCountRelay = PublishRelay<Double>()
    var timerCount: Double = 0.0
    
    init() {
        databaseRef = Database.database().reference()
        databaseRef.observe(.childAdded, with: { snapshot in
            if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message = obj["message"] {
                //                let currentText = self.textView.text
                //                self.textView.text = (currentText ?? "") + "\n\(name) : \(message)"
            }
        })
        btnTapped.bind(to: Binder(self) {me, _ in
            
            if !self.timer.isValid {
                self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.up), userInfo: nil,  repeats: true)
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
            
            var animations: [AnimationLayer] = []
            let animation1 = AnimationLayer(startTime: 1.0, endTime: 2.0, fromX: 100, fromY: 100, toX: 300, toY: 600)
            let animation2 = AnimationLayer(startTime: 3.0, endTime: 5.0, fromX: 0, fromY: 800, toX: 400, toY: 200)
            animations.append(animation1)
            animations.append(animation2)
            
            for animation in animations {
                let animationData = ["startTime": animation.startTime, "endTime": animation.endTime, "fromX": animation.fromX, "fromY": animation.fromY, "toX": animation.toX, "toY": animation.toY]
                self.databaseRef.child("animations") .childByAutoId().setValue(animationData)
            }
            
        }).disposed(by: disposeBag)
        
        
    }
    
    @objc func up() {
        timerCount += 0.01
        print(timerCount)
        self.timerCountRelay.accept(timerCount)
    }
    
    
}
