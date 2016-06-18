//
//  ViewController.swift
//  表情键盘
//
//  Created by 余亮 on 16/5/29.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //定义一个闭包属性
    var EmojiDidSelectBlock : ((emojicon : Emoticon) -> ())?
    init(callBack : (emojicon : Emoticon) -> ()){
        self.EmojiDidSelectBlock = callBack
        super.init(nibName: nil , bundle: nil )
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    
    @IBAction func ItemClick(sender: UIBarButtonItem) {
            print(self.customTextV.emoticonAttributeText())
    }
    
    
    @IBOutlet weak var customTextV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(emojiVC)
        //1,替换弹出键盘
        customTextV.inputView = emojiVC.view
        //2. 将表情键盘控制器的view设置为UITextView的inputView
        customTextV.inputView = emojiVC.view
        self.customTextV.font  = UIFont.systemFontOfSize(20)
        
    }

    
    //MARK:懒加载
       ///闭包的循环引用问题：
            //weak 相当于OC中的__weak, 特点：对象释放之后会将变量设置为nil
            //unowned  相当于OC中的unsafe_unretained, 特点：对象释放之后不会讲变量设置为nil
    
    private lazy var emojiVC : EmojiController = EmojiController {
        [unowned self ] (emoticon ) -> () in
//            print(emoticon.chs )
        ///还不能动态获取字体大小
      self.customTextV.insertEmoticon(emoticon, font: 20 )
    
    }
}


































