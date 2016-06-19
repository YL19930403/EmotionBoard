1.导入Emoticon  /N
2.添加表情控制器 ，懒加载一个Emoticon控制器 ，
    private lazy var emoticonVC : EmojiController = EmojiController{ [unowned self ] (emoticon) ->() in
            self.contentView.insertEmoticon(emoticon)
    }
    在viewDidLoad方法中  addChildViewController(emoticonVC)  /N
3.将表情控制器添加为当前控制器的子控制器 
    textView.inputView = emoticonVC.view
