//
//  BottomView.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/16.
//  Copyright © 2020 konatsup. All rights reserved.
//

import UIKit

class BottomView: UIView {
    private var fromXField: UITextField!
    private var fromYField: UITextField!
    private var toXField: UITextField!
    private var toYField: UITextField!
    private var startField: UITextField!
    private var endField: UITextField!
    private var button: UIButton!
    
    var viewModel = EditViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        let view = UIView()
        //        view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        //        addSubview(view)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    func make(viewModel: EditViewModel) {
        self.viewModel = viewModel
    }
    
    func loadNib() {
        let nib = UINib(nibName: "BottomView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    func setup() {
        
        let startLabel = UILabel()
        startLabel.frame = CGRect(x: 50, y: 70, width: 100, height: 38)
        startLabel.text = "START:"
        addSubview(startLabel)
        
        fromXField = UITextField()
        fromXField.frame = CGRect(x: 130, y: 70, width: 100, height: 38)
        fromXField.placeholder = "x"
        fromXField.keyboardType = .default
        fromXField.borderStyle = .roundedRect
        fromXField.returnKeyType = .done
        addSubview(fromXField)
        
        fromYField = UITextField()
        fromYField.frame = CGRect(x: 260, y: 70, width: 100, height: 38)
        fromYField.placeholder = "y"
        fromYField.keyboardType = .default
        fromYField.borderStyle = .roundedRect
        fromYField.returnKeyType = .done
        addSubview(fromYField)
        
        let endLabel = UILabel()
        endLabel.frame = CGRect(x: 50, y: 160, width: 50, height: 38)
        endLabel.text = "END:"
        addSubview(endLabel)
        
        toXField = UITextField()
        toXField.frame = CGRect(x: 130, y: 160, width: 100, height: 38)
        toXField.placeholder = "x"
        toXField.keyboardType = .default
        toXField.borderStyle = .roundedRect
        toXField.returnKeyType = .done
        addSubview(toXField)
        
        toYField = UITextField()
        toYField.frame = CGRect(x: 260, y: 160, width: 100, height: 38)
        toYField.placeholder = "y"
        toYField.keyboardType = .default
        toYField.borderStyle = .roundedRect
        toYField.returnKeyType = .done
        addSubview(toYField)
        
        let durationLabel = UILabel()
        durationLabel.frame = CGRect(x: 50, y: 250, width: 100, height: 38)
        durationLabel.text = "Time:"
        addSubview(durationLabel)
        
        startField = UITextField()
        startField.frame = CGRect(x: 130, y: 250, width: 100, height: 38)
        startField.placeholder = "start"
        startField.keyboardType = .default
        startField.borderStyle = .roundedRect
        startField.returnKeyType = .done
        addSubview(startField)
        
        endField = UITextField()
        endField.frame = CGRect(x: 260, y: 250, width: 100, height: 38)
        endField.placeholder = "end"
        endField.keyboardType = .default
        endField.borderStyle = .roundedRect
        endField.returnKeyType = .done
        addSubview(endField)
        
        button = UIButton()
        button.frame = CGRect(x: 120, y: 330, width: 180, height: 60)
        button.setTitle("追加", for: .normal)
        button.backgroundColor = UIColor.blueColor()
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(self.add), for: UIControl.Event.touchUpInside)
        addSubview(button)
        
        fromXField.delegate = self
        
    }
    
    @IBAction func add() {
        print("Add")
        //        let textFieldString = fromXField.text!
        
        let fromX = Double(fromXField.text!)!
        let fromY = Double(fromYField.text!)!
        let toX = Double(toXField.text!)!
        let toY = Double(toYField.text!)!
        let startTime = Double(startField.text!)!
        let endTime = Double(endField.text!)!
        let animation = AnimationLayer(startTime: startTime, endTime: endTime, fromX: fromX, fromY: fromY, toX: toX, toY: toY)
        viewModel.addAnimation(animation: animation)
        
        fromXField.text = ""
        fromYField.text = ""
        toXField.text = ""
        toYField.text = ""
        startField.text = ""
        endField.text = ""
    }
    
}

extension BottomView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return")
        return true
    }
    
    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("Clear")
        return true
    }
    
    // テキストフィールドがフォーカスされた時の処理
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Start")
        return true
    }
    
    // テキストフィールドでの編集が終了する直前での処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("End")
        return true
    }
}
