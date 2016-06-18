//
//  EmoticonTextAttachment.swift
//  表情键盘
//
//  Created by 余亮 on 16/6/18.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    //保存对应表情的文字
    var chs : String?
    
    class func imageText(emoticon : Emoticon , font : UIFont) -> NSAttributedString {
        //创建附件
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile:emoticon.imagePath!)
        //设置附件的大小
        let s = font.lineHeight
        attachment.bounds = CGRectMake(0, -4, s, s)
        //2.根据福监察局属性字符串
        return NSAttributedString(attachment: attachment)
    }

}
































