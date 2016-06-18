//
//  EmojiController.swift
//  表情键盘
//
//  Created by 余亮 on 16/5/29.
//  Copyright © 2016年 余亮. All rights reserved.
//


import UIKit


private let EmojiBoardReuseIdentifier = "EmojiBoardReuseIdentifier"

class EmojiController: UIViewController {

    
    ///定义闭包，用于传递我们选中的表情
    var emotionDidSelectedCallBack:((emoticon : Emoticon) -> ())?
    
    init(callBack : (emoticon : Emoticon) -> () ){
        self.emotionDidSelectedCallBack = callBack
        super.init(nibName: nil , bundle: nil )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
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
        collectionV.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.tag), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true )
    }
    
    
    //MARK: 懒加载
    private lazy var collectionV : UICollectionView = {
        let view = UICollectionView(frame:CGRectZero,collectionViewLayout: EmojiLayout())
            view.registerClass(EmojiCell.self, forCellWithReuseIdentifier: EmojiBoardReuseIdentifier)
            view.dataSource = self
            view.delegate = self
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

    private lazy var packages : [EmojiPackage] = EmojiPackage.loadPackages()
}


extension EmojiController :UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
  

    func numberOfSectionsInCollectionView(collectionView:UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionV.dequeueReusableCellWithReuseIdentifier(EmojiBoardReuseIdentifier, forIndexPath: indexPath) as! EmojiCell
        cell.backgroundColor = (indexPath.item % 2 == 0 ) ? UIColor.redColor() : UIColor.blueColor()
        
        //1.取出对应的组
        let package = packages[indexPath.section]
        //2.取出对应组对应行的模型
        let emoticon = package.emoticons![indexPath.item]
        
        //3.赋值给cell
        cell.emoticon = emoticon
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)
        //1.处理最近表情，将当前使用的表情添加到最近表情的数组中
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        emoticon.times++
        packages[0].appendEmotions(emoticon)
        
        ///拿到对应组的对应的模型
//        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        emotionDidSelectedCallBack!(emoticon : emoticon)
    }
}

//自定义布局
class EmojiLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        let width = (collectionView?.bounds.width)! / 7
        itemSize = CGSize(width:width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
     
        //注意：最好不要乘以0.5 ， 因为CGFloat是不正确的
        let y = (collectionView!.bounds.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        
        
    }
}

class EmojiCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }
    
    var emoticon : Emoticon?{
        didSet{
            //1.判断是否是图片表情
            if (emoticon!.chs != nil) {
                iconButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), forState: UIControlState.Normal)
            }else {
                //防止重用
                iconButton.setImage(nil , forState: UIControlState.Normal)
            }
            //2.设置emoji表情
                //注意：加上??  可以防止重用
            iconButton.setTitle(emoticon?.emojiStr ?? "", forState: UIControlState.Normal)
            //3.判断是否是删除按钮
            if emoticon!.isRemoveButton {
                iconButton.setImage(UIImage(named:"compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
                    iconButton.setImage(UIImage(named:"compose_emotion_delete"), forState: UIControlState.Normal)
            }
        }
    }
    
    func setUpSubViews(){
        contentView.addSubview(iconButton)
        iconButton.backgroundColor = UIColor.whiteColor()
        iconButton.frame = CGRectInset(contentView.bounds, 4, 4)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var iconButton : UIButton = {
            let btn = UIButton()
            btn.titleLabel?.font = UIFont.systemFontOfSize(32)
            btn.userInteractionEnabled = false
            return btn
    }()
}


































