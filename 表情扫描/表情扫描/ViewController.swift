//
//  ViewController.swift
//  表情扫描
//
//  Created by 余亮 on 16/5/30.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var customTextF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //emoji表情对应的十六进制
        let code = "0x2600"
        
        //1.从字符串中取出十六进制的数
          //创建一个扫描器，扫描器可以从字符串中提取我们想要的数据
        let scanner = NSScanner(string:code)
        
        //2. 将十六进制转换为字符串
        var result : UInt32 = 0
        scanner.scanHexInt(&result)
        
        //3.将十六进制转换为emoji字符串
        let emojiStr = Character(UnicodeScalar(result))
         //4.显示
        print(emojiStr)
        customTextF.text = String(emojiStr)
    }
    
    

}

























