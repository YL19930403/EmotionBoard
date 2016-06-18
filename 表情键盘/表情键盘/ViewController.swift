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
    
    
    @IBOutlet weak var customTextV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(emojiVC)
        //1,替换弹出键盘
        customTextV.inputView = emojiVC.view
        //2. 将表情键盘控制器的view设置为UITextView的inputView
        customTextV.inputView = emojiVC.view
        
    }

    
    //MARK:懒加载
       ///闭包的循环引用问题：
            //weak 相当于OC中的__weak, 特点：对象释放之后会将变量设置为nil
            //unowned  相当于OC中的unsafe_unretained, 特点：对象释放之后不会讲变量设置为nil
    
    private lazy var emojiVC : EmojiController = EmojiController {
        [unowned self ] (emoticon ) -> () in
//            print(emoticon.chs )
        //1.判断当前点击的是否是emoji表情
        if (emoticon.emojiStr != nil) {
            self.customTextV.replaceRange(self.customTextV.selectedTextRange! , withText : emoticon.emojiStr! )
        }
        
        //2.判断当前电机的是否是表情图片
        if (emoticon.png != nil ){
            //1.创建附件
            let attachment = NSTextAttachment()
            ///附件的大小就是文字字体的大小
            attachment.bounds = CGRectMake(0, -4, 20, 20)
            attachment.image = UIImage(contentsOfFile : emoticon.imagePath!)
            //2.根据附件创建属性字符串
            let imageText = NSAttributedString(attachment : attachment)
            //3.拿到当前所有的内容
            let strM = NSMutableAttributedString(attributedString : self.customTextV.attributedText)
            //4.插入表情到当前光标所在的位置
            let range = self.customTextV.selectedRange
            strM.replaceCharactersInRange(range, withAttributedString:imageText)
            ///属性字符串有自己默认的尺寸
            strM.addAttribute(NSFontAttributeName , value: UIFont.systemFontOfSize(20) , range:NSMakeRange(range.location, 1))
            
            //5.将替换后的字符串赋值给UITextView
            self.customTextV.attributedText = strM
            //6.恢复光标所在的位置
                //两个参数： 第一个指定光标所在的位置， 第二个选中文本的个数
            self.customTextV.selectedRange = NSMakeRange(range.location + 1 , 0)
        }
        
    }
    
    
}



































