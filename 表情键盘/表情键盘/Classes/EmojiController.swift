//
//  EmojiController.swift
//  表情键盘
//
//  Created by 余亮 on 16/5/29.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class EmojiController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.redColor()
        //1.设置子控件
        setUpSubView()

    }

    func setUpSubView(){
        //1.添加子控件
        view.addSubview(collectionV)
        view.addSubview(toolBar)
        
        //2.布局子控件
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionV" : collectionV , "toolBar" : toolBar]
        //水平方向布局
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionV]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views: dict )
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views: dict )
        
        //垂直方向布局
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionV]-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views: dict )
        
        view.addConstraints(cons)
        
    }
    
    func itemClick(item : UIBarButtonItem){
        print(item.tag)
    }
    
    
    //MARK: 懒加载
    private lazy var collectionV : UICollectionView = {
        let view = UICollectionView(frame:CGRectZero,collectionViewLayout: UICollectionViewFlowLayout())
        return view
    }()
    
    private lazy var toolBar : UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        var index = 0
        for title in ["最近","默认","emoji","浪小花"]{
            let item = UIBarButtonItem(title:title , style:UIBarButtonItemStyle.Plain, target:self,  action : #selector(EmojiController.itemClick(_:)))
            item.tag = index++   //自增运算符在Swift3.0中被放弃了
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FlexibleSpace, target: self, action:nil ))
        }
        items.removeLast()
        bar.items = items
        return bar
    }()

    
}
