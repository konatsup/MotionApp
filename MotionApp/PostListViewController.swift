//
//  PostListViewController.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/13.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

final class PostListViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        //セルのレイアウト設計
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //各々の設計に合わせて調整
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView( frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height ), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        //セルの登録
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        return collectionView
    }()
    
    private let disposeBag = DisposeBag()
    let viewModel = PostListViewModel()
    
    var projects: [Project] = []
    var cells: [PostCollectionViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.timerCountRelay
            .asDriver(onErrorJustReturn: 0)
            .drive(Binder(self) {me, timerCount in
                me.cells.forEach{ $0.drawView.update(timerCount) }
            })
            .disposed(by: disposeBag)
        
        //        viewModel.animationsRelay
        //        .asDriver(onErrorJustReturn: [])
        //        .drive(Binder(self) {me, animations in
        //            print("update animations")
        //            me.animations = animations
        //            me.collectionView.reloadData()
        //            me.cells.forEach{ $0.drawView.update(timerCount) }
        //        })
        //        .disposed(by: disposeBag)
        
        viewModel.projectsRelay
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) {me, projects in
                print("update animations")
                me.projects = projects
                me.collectionView.reloadData()
                
            })
            .disposed(by: disposeBag)
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("start", for: .normal)
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.center.equalTo(self.view.center)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button.rx.tap
            .bind(to: viewModel.btnTapped)
            .disposed(by: disposeBag)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    override func viewDidAppear(_ animated: Bool) {
        print("Did")
        viewModel.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("DisAppear")
        viewModel.stopTimer()
    }
    
    fileprivate func moveNextVC(indexPath: IndexPath) {
        
        let nextVC = EditViewController(project: projects[indexPath.item])
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
    
}

extension PostListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        
        cell.setAnimations(animations: self.projects[indexPath.item].animations)
        cells.append(cell)
        return cell
    }
}

extension PostListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveNextVC(indexPath: indexPath)
    }
}

extension PostListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //ここでは画面の横サイズの半分の大きさのcellサイズを指定
        return CGSize(width: screenSize.width / 2.0, height: screenSize.width / 2.0)
    }
}
