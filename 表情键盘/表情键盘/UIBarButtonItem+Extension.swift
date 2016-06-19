//
//  UIBarButtonItem+Extension.swift
//  WeiBoSwift
//
//  Created by 余亮 on 16/2/19.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    /**
    *  创建Item
        - parameter imageName: item显示图片
        - parameter target:    谁来监听
        - parameter action:    监听到之后执行的方法
    */
//    convenience init(imageName:String,target:AnyObject?, action:Selector){
//        let btn = UIButton()
//        btn.setImage(UIImage(named:imageName), forState: UIControlState.Normal)
//        btn.setImage(UIImage(named: imageName+"_highlighted" ), forState:UIControlState.Highlighted )
//        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
//        btn.sizeToFit()
//        self.init(customView:btn)
//    }
    
    
    convenience init(imageName : String, target : AnyObject? , action : String?) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        if (action != nil){
             // 如果是自己封装一个按钮, 最好传入字符串, 然后再将字符串包装为Selector
            btn.addTarget(target, action:Selector(action!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        btn.sizeToFit()
        self.init(customView:btn)
        
    }
    
    // 如果在func前面加上class, 就相当于OC中的+
    class func creatBarButtonItem(imageName:String, target: AnyObject?, action:Selector) ->UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
    }

}














