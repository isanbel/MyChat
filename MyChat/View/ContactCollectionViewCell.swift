//
//  ContactCollectionViewCell.swift
//  MyChatContactDemo
//
//  Created by Yuanyuan Zhang on 15/03/2018.
//  Copyright © 2018 Isanbel. All rights reserved.
//

import UIKit

let imageW:CGFloat = 60

let kVibrateAnimation = "kVibrateAnimation"
let VIBRATE_DURATION: CGFloat = 0.1
let VIBRATE_RADIAN = CGFloat(Double.pi/96)

class ContactCollectionViewCell: UICollectionViewCell {
    
    var remove: (()->())?
    
    var id: String
    
    var name: String {
        didSet {
            nameLabel.text = name
        }
    }
    
    var image: UIImage {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        self.id = ""
        self.name = ""
        self.image = UIImage()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(removeBtn)
    }
    
    private lazy var imageView: UIImageView = {
        
        let image = UIImageView(frame: CGRect(x: 10, y: 10, width: imageW, height: imageW))
        image.image = UIImage()
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: imageW + 10 + 5, width: self.bounds.width, height: 14))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var removeBtn: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.setBackgroundImage(UIImage(named: "delete_collect_btn"), for: .normal)
        btn.addTarget(self, action: #selector(removeBtnClick), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    @objc func removeBtnClick() {
        remove!()
    }
    
    var isEditing: Bool {
        get {
            return vibrating
        }
        set {
            vibrating = newValue
            removeBtn.isHidden = !newValue
        }
    }
    
    private var vibrating: Bool {
        get {
            if let animationKeys = contentView.layer.animationKeys() {
                return animationKeys.contains(kVibrateAnimation)
            }
            else {
                return false
            }
        }
        set {
            var _vibrating = false
            if let animationKeys = layer.animationKeys() {
                _vibrating = animationKeys.contains(kVibrateAnimation)
            }
            else {
                _vibrating = false
            }
            
            if _vibrating && !newValue {
                layer.removeAnimation(forKey: kVibrateAnimation)
            }
            else if !_vibrating && newValue {
                let vibrateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                vibrateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                vibrateAnimation.fromValue = -VIBRATE_RADIAN
                vibrateAnimation.toValue = VIBRATE_RADIAN
                vibrateAnimation.autoreverses = true
                vibrateAnimation.duration = CFTimeInterval(VIBRATE_DURATION)
                vibrateAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
                vibrateAnimation.beginTime = CACurrentMediaTime() + 0.01 * Double(arc4random_uniform(10))
                layer.add(vibrateAnimation, forKey: kVibrateAnimation)
            }
        }
    }
}

