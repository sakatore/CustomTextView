//
//  CustomTextView.swift
//  CustomTextView
//
//  Created by 酒井恭平 on 2016/10/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    private let placeholderLabel = UILabel()
    
    // default is nil. string is drawn 70% gray
    var placeholder: String? {
        didSet {
            print("placeholder did set.")
            drawPlaceholder(in: frame)
        }
    }
    
    func drawPlaceholder(in rect: CGRect) {
        // 通知を登録する
        NotificationCenter.default.addObserver(self, selector: #selector(controlPlaceholder(_:)), name: .UITextViewTextDidChange, object: nil)
    }
    
    //  TextViewのTextが変更された時に呼ばれる
    func controlPlaceholder(_ notification: NSNotification) {
        print("UITextViewTextDidChange!")
        placeholderIsHidden()
        
    }
    
    private func placeholderIsHidden() {
        if text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
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
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        placeholderLabel.frame = rect
        placeholderLabel.text = placeholder
        placeholderLabel.font = self.font
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.7)
        placeholderLabel.textAlignment = self.textAlignment
        placeholderLabel.sizeToFit()
        
        self.addSubview(placeholderLabel)
        self.sendSubview(toBack: placeholderLabel)
        print("Add placeholderLabel as subView")
    }

}
