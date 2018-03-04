//
//  ChatMessageCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 02/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//  Reference: https://github.com/bb-coder/swift-chatView
//

import UIKit

class ChatMessageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //头像
    let headerImgView:UIImageView = UIImageView()
    //内容
    let contentLbl:UILabel = UILabel()
    //气泡
    let bubbleImgView:UIImageView = UIImageView()
    
    // the data of friend is not user for convenience
    var friend: ChatOutline?
    var me: User?
    
    var message: ChatMessage? {//根据消息模型构建cell布局
        
        didSet{
            //当message传入时初始化视图，先移除，再添加，避免cell复用时候重复添加视图
            self.headerImgView.removeFromSuperview()
            self.contentLbl.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentLbl)
            
            //将message模型中的数据给头像、内容、气泡视图
            self.headerImgView.image = message?.msgType == MsgType.Sent ? UIImage(named: me!.avatar) : UIImage(named: friend!.avatar)
            self.bubbleImgView.image = message?.msgType != MsgType.Sent ? UIImage(named: "bubble_received_normal") : UIImage(named: "bubble_sent_normal")
            self.contentLbl.text = message?.contentText
            
            //布局位置
            //1.去掉系统添加默认的autolayout，防止冲突,并设置label的对齐
            self.headerImgView.translatesAutoresizingMaskIntoConstraints = false
            self.contentLbl.translatesAutoresizingMaskIntoConstraints = false
            self.bubbleImgView.translatesAutoresizingMaskIntoConstraints = false
            self.contentLbl.textAlignment = message?.msgType != MsgType.Sent ? NSTextAlignment.right : NSTextAlignment.left
            self.contentLbl.numberOfLines = 0
            
            
            //2.设置约束
            let viewsDictionary = ["header": self.headerImgView, "content": self.contentLbl, "bubble": self.bubbleImgView]
            var header_constraint_H_Format = ""
            var header_constraint_V_Format = ""
            var bubble_constraint_H_Format = ""
            var bubble_constraint_V_Format = ""
            var content_constraint_H_Format = ""
            var content_constraint_V_Format = ""
            
            
            if message?.msgType == MsgType.Sent {
                header_constraint_H_Format =  "[header(40)]-7-|"
                header_constraint_V_Format =  "V:|-5-[header(40)]"
                bubble_constraint_H_Format  =  "|-(>=57)-[bubble]-5-[header]"
                bubble_constraint_V_Format  =  "V:|-5-[bubble(>=43)]-5-|"
                content_constraint_H_Format  =  "|-(>=10)-[content]-15-|"
                content_constraint_V_Format  =  "V:|-10-[content]-12-|"
            } else {
                header_constraint_H_Format =  "|-7-[header(40)]"
                header_constraint_V_Format =  "V:|-5-[header(40)]"
                bubble_constraint_H_Format  =  "[header]-5-[bubble]-(>=57)-|"
                bubble_constraint_V_Format  =  "V:|-5-[bubble(>=43)]-5-|"
                content_constraint_H_Format  =  "|-15-[content]-(>=10)-|"
                content_constraint_V_Format  =  "V:|-10-[content]-12-|"
            }
            
            
            let header_constraint_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: header_constraint_H_Format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary) as NSArray
            let header_constraint_V:NSArray = NSLayoutConstraint.constraints(withVisualFormat: header_constraint_V_Format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary) as NSArray
            
            let bubble_constraint_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: bubble_constraint_H_Format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary) as NSArray
            let bubble_constraint_V:NSArray = NSLayoutConstraint.constraints(withVisualFormat: bubble_constraint_V_Format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary) as NSArray
            
            let content_constraint_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: content_constraint_H_Format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary) as NSArray
            let content_constraint_V:NSArray = NSLayoutConstraint.constraints(withVisualFormat: content_constraint_V_Format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary) as NSArray
            
            self.contentView.addConstraints(header_constraint_H as! [NSLayoutConstraint])
            self.contentView.addConstraints(header_constraint_V as! [NSLayoutConstraint])
            self.contentView.addConstraints(bubble_constraint_H as! [NSLayoutConstraint])
            self.contentView.addConstraints(bubble_constraint_V as! [NSLayoutConstraint])
            self.bubbleImgView.addConstraints(content_constraint_H as! [NSLayoutConstraint])
            self.bubbleImgView.addConstraints(content_constraint_V as! [NSLayoutConstraint])
            
            self.contentLbl.font = UIFont.systemFont(ofSize: 16)
            
            // TODO: set no select style
            self.selectionStyle = .none
            self.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        }
    }
    
}

