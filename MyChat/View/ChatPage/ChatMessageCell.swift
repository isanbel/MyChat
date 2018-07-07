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

    var showProfile: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //头像
    lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapped)))
        headerImgView.isUserInteractionEnabled = true
        return headerImgView
    }()
    //内容
    var contentLbl:UITextView = UITextView()
    //气泡
    let bubbleImgView:UIImageView = UIImageView() 
    
    var friend: FriendMO?
    var me: UserMO?
    
    var lastMessage: ChatMessageMO?
    var message: ChatMessageMO? {//根据消息模型构建cell布局
        
        didSet{
            //当message传入时初始化视图，先移除，再添加，避免cell复用时候重复添加视图
            self.headerImgView.removeFromSuperview()
            self.contentLbl.removeFromSuperview()
            self.bubbleImgView.removeFromSuperview()
            self.contentView.addSubview(self.headerImgView)
            self.contentView.addSubview(self.bubbleImgView)
            self.bubbleImgView.addSubview(self.contentLbl)
            
            //将message模型中的数据给头像、内容、气泡视图
            
            if message?.isSent == true {
                if let avatarImage = me!.avatar {
                    self.headerImgView.image = UIImage(data: avatarImage as Data)
                }
            } else {
                if let avatarImage = friend!.avatar {
                    self.headerImgView.image = UIImage(data: avatarImage as Data)
                }
            }
            self.bubbleImgView.image = message?.isSent == false ? UIImage(named: "bubble_received_normal") : UIImage(named: "bubble_sent_normal")
            self.contentLbl.text = message?.contentText
            
            // resizable image
            self.bubbleImgView.image? = (self.bubbleImgView.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 20, 20, 20)))!
            
            //布局位置
            //1.去掉系统添加默认的autolayout，防止冲突
            self.headerImgView.translatesAutoresizingMaskIntoConstraints = false
            self.contentLbl.translatesAutoresizingMaskIntoConstraints = false
            self.bubbleImgView.translatesAutoresizingMaskIntoConstraints = false
            self.contentLbl.textColor = message?.isSent == true ? UIColor.white : UIColor.black
            self.contentLbl.isScrollEnabled = false
            self.contentLbl.layer.backgroundColor = UIColor.clear.cgColor
            // To enable selection
            self.contentLbl.isEditable = false
            self.contentLbl.isSelectable = true
            // TextVeiw is the subview of ImgView, while the ImgView.isUserInteractionEnabled is  false by default
            self.bubbleImgView.isUserInteractionEnabled = true
            
            //2.设置约束
            let viewsDictionary = ["header": self.headerImgView, "content": self.contentLbl, "bubble": self.bubbleImgView] as [String : Any]
            var header_constraint_H_Format = ""
            var header_constraint_V_Format = ""
            var bubble_constraint_H_Format = ""
            var bubble_constraint_V_Format = ""
            var content_constraint_H_Format = ""
            var content_constraint_V_Format = ""
            
            let sameMsgType = lastMessage?.isSent == message?.isSent && lastMessage?.isDateIdentifier == false
            
            if message?.isSent == true {
                header_constraint_H_Format =  "[header(0)]-10-|"
                header_constraint_V_Format =  "V:|-6-[header(0)]"
                bubble_constraint_H_Format  =  "|-(>=57)-[bubble(>=40)]-5-[header]"
                bubble_constraint_V_Format  =  "V:|-6-[bubble(>=40)]-6-|"
                content_constraint_H_Format  =  "|-(>=10)-[content]-10-|"
                content_constraint_V_Format  =  "V:|-3-[content]-3-|"
                
                if sameMsgType {
                    header_constraint_V_Format =  "V:|-0-[header(0)]"
                }
            } else {
                header_constraint_H_Format =  "|-10-[header(40)]"
                header_constraint_V_Format =  "V:|-6-[header(40)]"
                bubble_constraint_H_Format  =  "[header]-5-[bubble(>=40)]-(>=57)-|"
                bubble_constraint_V_Format  =  "V:|-6-[bubble(>=40)]-6-|"
                content_constraint_H_Format  =  "|-10-[content]-(>=10)-|"
                content_constraint_V_Format  =  "V:|-3-[content]-3-|"
                
                if sameMsgType {
                    header_constraint_V_Format =  "V:|-0-[header(40)]"
                }
            }
            
            if sameMsgType {
                bubble_constraint_V_Format  =  "V:|-0-[bubble(>=43)]-6-|"
                self.headerImgView.image = UIImage(data: Data())
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
            // be round
            self.headerImgView.layer.cornerRadius = 20
            self.headerImgView.clipsToBounds = true
            
            self.selectionStyle = .none
            // self.backgroundColor = UIColor(displayP3Red: 237/255, green: 235/255, blue: 235/255, alpha: 1)
        }
    }
    
    @objc func avatarTapped() {
        showProfile!()
    }
}

