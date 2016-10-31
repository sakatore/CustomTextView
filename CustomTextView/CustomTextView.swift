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
            
            // 表示可能最大行数を指定(0 -> 行数は可変)
            placeholderLabel.numberOfLines = 0
            placeholderLabel.sizeToFit()
            // 単語の途中で改行されないようにする
            placeholderLabel.lineBreakMode = .byWordWrapping
        }
    }
    
    
    // MARK: - initializers
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        observeTextDidChange()
        configurePlaceholder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTextDidChange()
        configurePlaceholder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - private methods
    
    private func observeTextDidChange() {
        // 通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(controlPlaceholder(_:)), name: .UITextViewTextDidChange, object: nil)
    }
    
    // Placeholerの初期化設定(1回のみ)
    private func configurePlaceholder() {
        // default is clear
        placeholderLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        // default is 70% gray
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.7)
        
        // 変更され次第更新するもの
        placeholderLabel.font = font
        print(placeholderLabel.font.pointSize)
        placeholderLabel.textAlignment = textAlignment
        // default is (8, 0, 8, 0)
        self.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        self.addSubview(placeholderLabel)
        //        self.sendSubview(toBack: placeholderLabel)
        print("Add placeholderLabel as subView")
    }
    
    //  TextViewのTextが変更された時に呼ばれる
    @objc private func controlPlaceholder(_ notification: NSNotification) {
        print("Notification->UITextViewTextDidChange!")
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
            placeholderLabel.sizeToFit()
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            print("didiSet: \(textContainerInset)")
            placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + 2, y: textContainerInset.top)
            
            print(self.frame)
            print(placeholderLabel.textRect(forBounds: self.frame, limitedToNumberOfLines: 4))
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
