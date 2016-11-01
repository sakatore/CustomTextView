//
//  ViewController.swift
//  CustomTextView
//
//  Created by 酒井恭平 on 2016/10/14.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var textView = CustomTextView(frame: .zero)
    private var textField = UITextField(frame: .zero)
    
    private let width: CGFloat = 300
    private let textViewHeight: CGFloat = 300
    private let textFieldhHeight: CGFloat = 50
    private let buttonHeight: CGFloat = 50
    private var centerPositionX: CGFloat { return self.view.frame.width / 2}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureTextField()
        configureButton()
        
    }
    
    private func configureTextView() {
        textView.frame.size = CGSize(width: width, height: textViewHeight)
        textView.frame.origin = CGPoint(x: centerPositionX - width / 2, y: 100)
        textView.text = "Fist text"
        textView.placeholder = "Placeholder is the Placeholder a Placeholder for Placeholder"
//        textView.textAlignment = .center
        textView.delegate = self
        
        view.addSubview(textView)
    }
    
    private func configureTextField() {
        textField.frame.size = CGSize(width: width, height: textFieldhHeight)
        textField.frame.origin = CGPoint(x: centerPositionX - width / 2, y: textView.frame.origin.y + textViewHeight)
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textField.text = "Fist text"
        textView.font = .systemFont(ofSize: 22.0)
        textField.placeholder = "Placeholder"
        textField.borderStyle = .line
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChanged(_:)), name: .UITextFieldTextDidChange, object: nil)
        
        view.addSubview(textField)
    }
    
    @objc private func textFieldTextDidChanged(_ notification: NSNotification) {
        print("Notification->UITextFieldTextDidChange!")
    }
    
    private func configureButton() {
        let size = CGSize(width: width, height: buttonHeight)
        let point = CGPoint(x: centerPositionX - width / 2, y: textField.frame.origin.y + textFieldhHeight)
        let button = UIButton(frame: CGRect(origin: point, size: size))
        button.setTitle("Button", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle("Pushed", for: .highlighted)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc private func tapButton(_ sender: UIButton) {
        print("TapButton!")
        // textを追加
//        textView.text = textView.text + "+addText"
//        textField.text = textField.text ?? "" + "+addText"
        
        // textSizeを変更
        if let text = textField.text, let size = Int(text) {
            textView.font = .systemFont(ofSize: CGFloat(size))
        }
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







