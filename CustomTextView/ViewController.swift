//
//  ViewController.swift
//  CustomTextView
//
//  Created by 酒井恭平 on 2016/10/14.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var textView = CustomTextView()
    var textField = UITextField()
    
    let width: CGFloat = 200
    let textViewHeight: CGFloat = 100
    let textFieldhHeight: CGFloat = 50
    let buttonHeight: CGFloat = 50
    var centerPositionX: CGFloat { return self.view.frame.width / 2}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureTextField()
        configureButton()
        
    }
    
    func configureTextView() {
        textView.frame.size = CGSize(width: width, height: textViewHeight)
        textView.layer.position = CGPoint(x: centerPositionX, y: 100)
        textView.text = "Fist text"
        textView.placeholder = "Placeholder"
        textView.delegate = self
        
        view.addSubview(textView)
    }
    
    func configureTextField() {
        textField.frame.size = CGSize(width: width, height: textFieldhHeight)
        textField.layer.position = CGPoint(x: centerPositionX, y: 100 + textViewHeight / 2 + textViewHeight / 2)
        textField.text = "Fist text"
        textField.placeholder = "Placeholder"
        textField.borderStyle = .line
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChanged(_:)), name: .UITextFieldTextDidChange, object: nil)
        
        view.addSubview(textField)
    }
    
    func textFieldTextDidChanged(_ notification: NSNotification) {
        print("Notification->UITextFieldTextDidChange!")
    }
    
    func configureButton() {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: width, height: buttonHeight)
        button.layer.position = CGPoint(x: centerPositionX, y: textField.layer.position.y + textFieldhHeight / 2 + buttonHeight / 2)
        button.setTitle("Button", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle("Pushed", for: .highlighted)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.addTarget(self, action: #selector(ViewController.tapButton(_:)), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    func tapButton(_ sender: UIButton) {
        print("TapButton!")
        textView.text = textView.text + "+addText"
//        textView.textAlignment = .center
        textField.text = textField.text! + "+addText"
    }

}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("Delegate->textViewDidChange")
    }
    
}







