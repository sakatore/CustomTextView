//
//  CustomTextView.swift
//  CustomTextView
//
//  Created by 酒井恭平 on 2016/10/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

@IBDesignable
final class CustomTextView: UITextView {
    
    // MARK: - placeholer
    
    private let placeholderLabel = UILabel()
    
    // default is nil. string is drawn 70% gray
    @IBInspectable var placeholder: String? {
        didSet {
            print("placeholder did set.")
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    // adjust label position
    private let paddingLeft: CGFloat = 2
    
    
    // MARK: - initializers
    
    override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        observeTextDidChange()
        configurePlaceholder()
        configureAccessoryView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTextDidChange()
        configurePlaceholder()
        configureAccessoryView()
    }
    
    deinit {
        notificatin.removeObserver(self)
    }
    
    
    // MARK: - private methods
    
    private let notificatin = NotificationCenter.default
    
    private func observeTextDidChange() {
        // 通知を登録する
        notificatin.addObserver(self, selector: #selector(controlPlaceholder(_:)), name: .UITextViewTextDidChange, object: nil)
    }
    
    // Placeholerの初期化設定(1回のみ)
    private func configurePlaceholder() {
        // default is clear
//        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        // default is 70% gray
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.7)
        // 表示可能最大行数を指定(0 -> 行数は可変)
        placeholderLabel.numberOfLines = 0
        // 単語の途中で改行されないようにする
        placeholderLabel.lineBreakMode = .byWordWrapping
        
        // 変更され次第更新するもの
        placeholderLabel.font = font
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + paddingLeft, y: textContainerInset.top)
        placeholderLabel.sizeToFit()
        
        self.addSubview(placeholderLabel)
    }
    
    //  TextViewのTextが変更された時に呼ばれる
    @objc private func controlPlaceholder(_ notification: NSNotification) {
//        print("Notification->UITextViewTextDidChange!")
        placeholderIsHidden()
    }
    
    private func placeholderIsHidden() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
    // MARK: - override properties
    
    override var text: String! {
        didSet {
            print("didiSet: " + text)
            placeholderIsHidden()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            print("didiSet: \(textAlignment)")
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override var font: UIFont? {
        didSet {
            print("didiSet: \(font)")
            placeholderLabel.font = font
            placeholderLabel.frame.size.width = textContainer.size.width - paddingLeft * 2
            placeholderLabel.sizeToFit()
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            print("didiSet: \(textContainerInset)")
            placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + paddingLeft, y: textContainerInset.top)
        }
    }
    
    // MARK: - accessoryView
    
    private let accessoryView = UIToolbar()
    
    private var doneButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(doneButtonDidPush(_:)))
    
    var buttonTitle: String = "Done" {
        didSet {
            doneButton.title = buttonTitle
        }
    }
    
    var accessoryViewStyle: UIBarStyle = .default {
        didSet {
            accessoryView.barStyle = accessoryViewStyle
        }
    }
    
    // defaultではaccessoryViewを表示
    var accessoryViewIsHidden = false {
        didSet {
            accessoryView.isHidden = accessoryViewIsHidden
        }
    }
    
    private func configureAccessoryView() {
        doneButton.title = buttonTitle
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryView.setItems([spacer, doneButton], animated: false)
        
        // ツールバーをtextViewのアクセサリViewに設定する
        self.inputAccessoryView = accessoryView
        accessoryView.sizeToFit()
        accessoryView.isHidden = accessoryViewIsHidden
        accessoryView.barStyle = accessoryViewStyle
    }
    
    
    // MARK: - delegate
    
    var customDelegate: CustomTextViewDelegate? {
        didSet {
            delegate = customDelegate
        }
    }
    
    @objc private func doneButtonDidPush(_ sender: UIButton) {
        if customDelegate?.customTextViewShouldDone(self) != false {
            // キーボードを閉じる
            self.resignFirstResponder()
        }
    }

}


protocol CustomTextViewDelegate: UITextViewDelegate {
    func customTextViewShouldDone(_ textView: CustomTextView) -> Bool
}














