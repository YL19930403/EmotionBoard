//
//  ViewController.swift
//  表情键盘
//
//  Created by 余亮 on 16/5/29.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var customTextV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(emojiVC)
        //替换弹出键盘
        customTextV.inputView = emojiVC.view
        
    }

    
    //MARK:懒加载
    private lazy var emojiVC : EmojiController = EmojiController()
}

