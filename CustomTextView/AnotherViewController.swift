//
//  AnotherViewController.swift
//  CustomTextView
//
//  Created by 酒井恭平 on 2016/11/13.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class AnotherViewController: UIViewController {
    
    @IBOutlet weak var textView: CustomTextView!
    
    private var sizeTextField = UITextField(frame: .zero)
    private var insetTextField = UITextField(frame: .zero)
    private var addTextField = UITextField(frame: .zero)
    
    private let width: CGFloat = 300
    private let textViewHeight: CGFloat = 300
    private let textFieldhHeight: CGFloat = 50
    private let buttonHeight: CGFloat = 50
    
    private var centerPositionX: CGFloat { return self.view.frame.width / 2}
    private var textViewBottom: CGFloat { return textView.frame.origin.y + textViewHeight }
    private var textFieldBottom: CGFloat { return textViewBottom + textFieldhHeight }
    
    private let textFieldPlaceholder = ["20", "12", "Hello,.."]
    private let textFieldKeyboardType: [UIKeyboardType] = [.numberPad, .numberPad, .default]
    
    private let buttonTitle = ["Change", "Change", "Add"]
    private let buttonSelector = [#selector(tapSizeButton(_:)), #selector(tapInsetButton(_:)), #selector(tapAddTextButton(_:))]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureTextField()
        configureButton()
        
    }
    
    private func configureTextView() {
        textView.frame.size = CGSize(width: width, height: textViewHeight)
        textView.frame.origin = CGPoint(x: centerPositionX - width / 2, y: 100)
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
//        textView.font = .systemFont(ofSize: 22.0)
        textView.keyboardAppearance = .dark
        
        textView.customDelegate = self
        
        view.addSubview(textView)
    }
    
    private func configureTextField() {
        let textFields = [sizeTextField, insetTextField, addTextField]
        for index in 0..<textFieldPlaceholder.count {
            let size = CGSize(width: width / 3, height: textFieldhHeight)
            let point = CGPoint(x: centerPositionX - width / 2 + size.width * CGFloat(index), y: textViewBottom)
            textFields[index].frame = CGRect(origin: point, size: size)
            textFields[index].placeholder = textFieldPlaceholder[index]
            textFields[index].keyboardType = textFieldKeyboardType[index]
            textFields[index].textAlignment = .center
            textFields[index].borderStyle = .line
            textFields[index].delegate = self
            view.addSubview(textFields[index])
        }
        
    }
    
    private func configureButton() {
        for index in 0..<buttonTitle.count {
            let size = CGSize(width: width / 3, height: buttonHeight)
            let point = CGPoint(x: centerPositionX - width / 2 + size.width * CGFloat(index), y: textFieldBottom)
            let button = UIButton(frame: CGRect(origin: point, size: size))
            button.setTitle(buttonTitle[index], for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.addTarget(self, action: buttonSelector[index], for: .touchUpInside)
            view.addSubview(button)
        }
    }
    
    @objc private func tapSizeButton(_ sender: UIButton) {
        // textSizeを変更
        if let text = sizeTextField.text, let size = Int(text) {
            textView.font = .systemFont(ofSize: CGFloat(size))
        }
    }
    
    @objc private func tapInsetButton(_ sender: UIButton) {
        // textContainerInsetを変更
        if let text = insetTextField.text, let top = Int(text) {
            textView.textContainerInset.top = CGFloat(top)
            textView.textContainerInset.left = CGFloat(top)
        }
    }
    
    @objc private func tapAddTextButton(_ sender: UIButton) {
        // textを追加
        if let text = addTextField.text {
            textView.text = textView.text + text
        }
    }

}


// MARK: - delegate methods

extension AnotherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension AnotherViewController: CustomTextViewDelegate {
    
    func customTextViewShouldDone(_ textView: CustomTextView) -> Bool {
        return true
    }
    
}






