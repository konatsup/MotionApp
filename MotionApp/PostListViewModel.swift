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

class Project {
//    var duration: Double
    var animations: [AnimationLayer]
    init(dict: [String: Any]) {
//        self.duration = dict["duration"] as! Double
        let animations = dict["animations"] as! [Any]
        self.animations = animations.map { AnimationLayer(dict: $0 as! [String : Any]) }
    }
}

final class PostListViewModel {
    private let disposeBag = DisposeBag()
    
    var databaseRef: DatabaseReference!
    
    //input
    var btnTapped = PublishRelay<Void>()
    
    //output
    var timer: Timer = Timer()
    var timerCountRelay = PublishRelay<Double>()
    var timerCount: Double = 0.0
    
    var animationsRelay = PublishRelay<[AnimationLayer]>()
    //    var animations: [AnimationLayer] = []
    
    var projectsRelay = PublishRelay<[Project]>()
    var projects: [Project] = []
    
    let maxRepeatTime = 5.0
    
    init() {
        databaseRef = Database.database().reference()
        databaseRef.child("projects").observe(.value, with: { snapshot in
            if let obj = snapshot.value as? [String : AnyObject]  {
                obj.keys.forEach {
                    let project = Project(dict: obj[$0] as! [String : Any])
                    self.projects.append(project)
                }
                self.projectsRelay.accept(self.projects)
            }
        })
        
        print("init PLViewModel")
        if !self.timer.isValid {
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.up), userInfo: nil,  repeats: true)
        }
        
    }
    
    @objc func up() {
        if timerCount < maxRepeatTime {
            timerCount += 0.01
        } else {
            timerCount = 0
        }
        //        print(timerCount)
        self.timerCountRelay.accept(timerCount)
        
    }
    
}
