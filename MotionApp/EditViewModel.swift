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
    
    //input
    var btnTapped = PublishRelay<Void>()

    //output
    var entityRelay = PublishRelay<Entity>()
    var e = Entity()
    
    var timer: Timer = Timer()
    var timerCountRelay = PublishRelay<Double>()
    var timerCount: Double = 0.0
    
    init() {
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
        
        
    }
    
    @objc func up() {
        timerCount += 0.01
        print(timerCount)
        self.timerCountRelay.accept(timerCount)
    }
    
    
}
