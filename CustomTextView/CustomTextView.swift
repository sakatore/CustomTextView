//
//  CustomTextView.swift
//  CustomTextView
//
//  Created by 酒井恭平 on 2016/10/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

// MARK: - CustomTextViewDelegate -

protocol CustomTextViewDelegate: UITextViewDelegate {
    func customTextViewShouldDone(_ textView: CustomTextView) -> Bool
}


// MARK: - CustomTextView -

@IBDesignable
final class CustomTextView: UITextView {
    
    // MARK: - fileprivate properties -
    
    // placeholer
    fileprivate let placeholderLabel = UILabel()
    // adjust label position
    fileprivate let paddingLeft: CGFloat = 2
    
    fileprivate let notificatin = NotificationCenter.default
    
    fileprivate var doneButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(doneButtonDidPush(_:)))
    
    
    // MARK: - Initialization -
    
    override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        observeTextDidChange()
        configurePlaceholder()
        configureAccessoryView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init(coder: aDecoder)")
        observeTextDidChange()
        configurePlaceholder()
        print("configurePlaceholder()")
        configureAccessoryView()
    }
    
    deinit {
        notificatin.removeObserver(self)
    }
    
    
    // MARK: - override properties -
    
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
            adjustLabelToFit()
            
            contentSize.height = placeholderLabel.frame.height + textContainerInset.top + textContainerInset.bottom
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            print("didiSet: \(textContainerInset)")
            placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + paddingLeft, y: textContainerInset.top)
            
//            if oldValue.left != textContainerInset.left {
//                placeholderLabel.frame.size.width = placeholderLabel.frame.width + oldValue.left - textContainerInset.left
//            }
//            
//            if oldValue.right != textContainerInset.right {
//                placeholderLabel.frame.size.width = placeholderLabel.frame.width + oldValue.right - textContainerInset.right
//            }
            
            placeholderLabel.frame.size.width = placeholderLabel.frame.width + (oldValue.left - textContainerInset.left) + (oldValue.right - textContainerInset.right)
            
            contentSize.height = placeholderLabel.frame.height + textContainerInset.top + textContainerInset.bottom
        }
    }
    
    override var frame: CGRect {
        didSet {
            adjustLabelToFit()
            contentSize.height = placeholderLabel.frame.height + textContainerInset.top + textContainerInset.bottom
        }
    }
    
    
    // MARK: - public properties -
    
    // default is nil. string is drawn 70% gray
    @IBInspectable var placeholder: String? {
        didSet {
//            print("placeholder did set.")
            placeholderLabel.text = placeholder
            adjustLabelToFit()
            print("adjustLabelToFit()")
            
            contentSize.height = placeholderLabel.frame.height + textContainerInset.top + textContainerInset.bottom
        }
    }
    
    @IBInspectable let accessoryView = UIToolbar()
    
    // defaultではaccessoryViewを表示
    @IBInspectable var accessoryViewIsHidden: Bool = false {
        didSet {
            accessoryView.isHidden = accessoryViewIsHidden
        }
    }
    
    @IBInspectable var barItemTitleColor: UIColor = UIColor.black {
        didSet {
            doneButton.setTitleTextAttributes([
                NSForegroundColorAttributeName: barItemTitleColor, NSFontAttributeName: barItemTitleFont], for: .normal)
        }
    }
    
    @IBInspectable var barItemTitle: String = "Done" {
        didSet {
            doneButton.title = barItemTitle
        }
    }
    
    var accessoryViewStyle: UIBarStyle = .default {
        didSet {
            accessoryView.barStyle = accessoryViewStyle
        }
    }
    
    var barItemTitleFont: UIFont = .systemFont(ofSize: UIFont.buttonFontSize) {
        didSet {
            doneButton.setTitleTextAttributes([
                NSFontAttributeName: barItemTitleFont, NSForegroundColorAttributeName: barItemTitleColor], for: .normal)
        }
    }
    
    var customDelegate: CustomTextViewDelegate? {
        didSet {
            delegate = customDelegate
        }
    }

}


// MARK: - private methods -

private extension CustomTextView {
    
    // MARK: - Placeholder -
    
    // TextViewのTextが変更された時に呼ばれる
    @objc func controlPlaceholder(_ notification: Notification) {
//        print("Notification->UITextViewTextDidChange!")
        placeholderIsHidden()
    }
    
    // キーボードを閉じる
    func observeTextDidChange() {
        // 通知を登録する
        notificatin.addObserver(self, selector: #selector(controlPlaceholder(_:)), name: .UITextViewTextDidChange, object: nil)
    }
    
    func placeholderIsHidden() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // Placeholerの初期化設定
    func configurePlaceholder() {
        // default is clear
//        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        // default is 70% gray
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.7)
        // 表示可能最大行数を指定(0 -> 行数は可変)
        placeholderLabel.numberOfLines = 0
        // 単語の途中で改行されないようにする
        placeholderLabel.lineBreakMode = .byWordWrapping
        
        placeholderLabel.font = font ?? .systemFont(ofSize: 12)
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + paddingLeft, y: textContainerInset.top)
        placeholderIsHidden()
        
        self.addSubview(placeholderLabel)
    }
    
    // text領域が変更された時に調整を行う
    func adjustLabelToFit() {
        placeholderLabel.frame.size.width = textContainer.size.width - paddingLeft * 2
        placeholderLabel.sizeToFit()
    }
    
    
    // MARK: - AccessaryView -
    
    @objc func doneButtonDidPush(_ sender: UIButton) {
        if customDelegate?.customTextViewShouldDone(self) != false {
            self.resignFirstResponder()
        }
    }
    
    func configureAccessoryView() {
        doneButton.title = barItemTitle
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryView.setItems([spacer, doneButton], animated: false)
        
        // ツールバーをtextViewのアクセサリViewに設定する
        self.inputAccessoryView = accessoryView
        accessoryView.sizeToFit()
        accessoryView.isHidden = accessoryViewIsHidden
        accessoryView.barStyle = accessoryViewStyle
    }
    
}













