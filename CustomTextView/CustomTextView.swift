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
    
    
    // MARK: - initializers
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        observeTextDidChange()
        initPlaceholder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    private func initPlaceholder() {
        placeholderLabel.frame = frame
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        placeholderLabel.frame.origin = CGPoint(x: 8, y: 5)
        // default is clear
        placeholderLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        // default is 70% gray
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.7)
        
        placeholderLabel.font = font
        print(placeholderLabel.font.pointSize)
        placeholderLabel.textAlignment = textAlignment
        
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
