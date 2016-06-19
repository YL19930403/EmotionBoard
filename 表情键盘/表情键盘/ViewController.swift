//
//  ViewController.swift
//  表情键盘
//
//  Created by 余亮 on 16/5/29.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit
import SnapKit

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.customTextV.becomeFirstResponder()
        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNoti()
        //初始化导航条
        setUpToolBar()
        
        addChildViewController(emojiVC)
        //1,替换弹出键盘
//        customTextV.inputView = emojiVC.view
        //2. 将表情键盘控制器的view设置为UITextView的inputView
//        customTextV.inputView = emojiVC.view
        self.customTextV.font  = UIFont.systemFontOfSize(20)
        
    }

    func registerNoti(){
                NSNotificationCenter.defaultCenter().addObserver(self , selector: #selector(ViewController.KeyBoardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil )
                NSNotificationCenter.defaultCenter().addObserver(self , selector: #selector(ViewController.KeyBoardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil )
    }
    
    func setUpToolBar(){
        //1.添加子控件
        view.addSubview(toolbar)
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings {
            let item = UIBarButtonItem(imageName: dict["imageName"]! , target:self , action : dict["action"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil , action: nil ))
        }
        items.removeLast()
        toolbar.items = items
        //3.布局toolbar
                 toolbar.snp_makeConstraints { (make) in
                    make.height.equalTo(44)
                    make.left.equalTo(view.snp_left)
                    make.right.equalTo(view.snp_right)
                    make.bottom.equalTo(view.snp_bottom)
                }
        
     
        
    }
    
    func KeyBoardWillShow(noti : NSNotification){
        let userInfo = noti.userInfo as [NSObject : AnyObject]! //noti.userInfo as! NSDictionary
        var keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue ).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        var  keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView: nil )
        var keyBoardViewFrame = toolbar.frame
        var deltaY = keyBoardBounds.size.height
        let animations :(() -> Void) = {
            UIView.animateWithDuration(0.25, animations: {
                
                self.toolbar.transform = CGAffineTransformMakeTranslation(0, -deltaY)
            })
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
        
        //更新界面
        let d = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        /*
         工具条回弹是因为执行了两次动画, 而系统自带的键盘的动画节奏(曲线) 7
         7在apple API中并没有提供给我们, 但是我们可以使用
         7这种节奏有一个特点: 如果连续执行两次动画, 不管上一次有没有执行完毕, 都会立刻执行下一次
         也就是说上一次可能会被忽略
         
         如果将动画节奏设置为7, 那么动画的时长无论如何都会自动修改为0.5
         
         UIView动画的本质是核心动画, 所以可以给核心动画设置动画节奏
         */
        ///1.取出键盘的动画节奏
        //        let curve = noti.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        //        UIView.animateWithDuration(d.doubleValue) {
        //            //2.设置动画节奏
        //            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:curve.integerValue)!)
        //            self.view.layoutIfNeeded()
        //        }
    }
    
    func KeyBoardWillHide(noti : NSNotification){
        let userInfo  = noti.userInfo as [NSObject : AnyObject]! //NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations : (()-> Void ) = {
            UIView.animateWithDuration(0.25, animations: {
                
                self.toolbar.transform = CGAffineTransformIdentity
            })
            
        }
        
        if (duration > 0){
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil )
        }else{
            animations()
        }
        
    }
    /**
        切换表情键盘
    */
    func inputEmoticon(){
        //如果是系统自带的键盘，那么inputView = nil
        //如果不是系统自带的键盘，那么inputView != nil
        //        print(contentView.inputView)
        //1.关闭键盘
        customTextV.resignFirstResponder()
        //2.设置inputView
        customTextV.inputView = (customTextV.inputView == nil ) ? emojiVC.view : nil
        
        //3.重新召唤出键盘
        customTextV.becomeFirstResponder()
    }
    
    func selectPicture() {
        
    }
    
    //MARK:懒加载
       ///闭包的循环引用问题：
            //weak 相当于OC中的__weak, 特点：对象释放之后会将变量设置为nil
            //unowned  相当于OC中的unsafe_unretained, 特点：对象释放之后不会讲变量设置为nil
    
    private lazy var emojiVC : EmojiController = EmojiController {
        [unowned self ] (emoticon ) -> () in
//            print(emoticon.chs )
        ///还不能动态获取字体大小
      self.customTextV.insertEmoticon(emoticon)
    
    }
    
    private lazy var toolbar : UIToolbar = {
        let toolbar = UIToolbar()
        return toolbar
    }()
}


































