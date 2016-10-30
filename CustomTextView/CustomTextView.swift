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
    private let placeholderLabel = UILabel()
    
    // default is nil. string is drawn 70% gray
    @IBInspectable var placeholder: String? {
        didSet {
            print("placeholder did set.")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: .null, textContainer: nil)
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        observeTextDidChange()
        configurePlaceholder(in: frame)
    }
    
    private func observeTextDidChange() {
        // 通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(controlPlaceholder(_:)), name: .UITextViewTextDidChange, object: nil)
    }
    
    private func configurePlaceholder(in rect: CGRect) {
        placeholderLabel.frame = rect
//        placeholderLabel.frame.origin = CGPoint.zero
        placeholderLabel.text = placeholder
        placeholderLabel.font = self.font
        placeholderLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.7)
        placeholderLabel.textAlignment = self.textAlignment
//        placeholderLabel.textAlignment = .center
        placeholderLabel.sizeToFit()
        
        addSubview(placeholderLabel)
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
    
    override var text: String! {
        didSet {
            print("didiSet: " + text)
            placeholderIsHidden()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            print("didiSet: \(textAlignment)")
            placeholderLabel.textAlignment = self.textAlignment
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
