//
//  ChatPageTableViewController+SwipInputBar.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 23/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height

extension ChatPageTableViewController: UIGestureRecognizerDelegate {
    
    // 为输入栏添加手势事件
    func addGestureToKeyBoardView() {
        
        let keyBoardSnapShot = keyBaordView.snapshot()
        keyBoardSnapShotView = UIImageView(image: keyBoardSnapShot)
        keyBoardSnapShotView.frame = CGRect(x: 0, y: 0, width: keyBaordView.frame.size.width, height: keyBaordView.frame.size.height)
        print(keyBoardSnapShotView.frame)
        keyBoardSnapShotView.isHidden = true
        self.view?.addSubview(keyBoardSnapShotView)
        keyBoardSnapShotView.layer.zPosition = 1
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.keyBaordView.addGestureRecognizer(swipeLeft)
        self.keyBaordView.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(gestrue: UIGestureRecognizer) {
        if let swipGesture = gestrue as? UISwipeGestureRecognizer {
            switch swipGesture.direction {
                case .left:
                    if keyBoardOnRight { return }
                    addSnapShotAndRearrangeKeyBoard()
                case .right:
                    if !keyBoardOnRight { return }
                    addSnapShotAndRearrangeKeyBoard()
                default:
                    break
            }
        }
    }
    
    func addSnapShotAndRearrangeKeyBoard() {
        // 当键盘升起的时候，要减去这部分高度
        let systemKeyBoardHeight = view.frame.height - keyBaordView.frame.size.height -  keyBaordView.frame.origin.y
        
        let originY = keyBaordView.frame.origin.y
        self.keyBoardSnapShotView.image = keyBaordView.snapshot()
        self.keyBoardSnapShotView.transform = CGAffineTransform(translationX: -0, y: originY)
        self.keyBoardSnapShotView.isHidden = false

        let duration = 0.5
        
        // 先将输入栏放在滑动目的地
        self.keyBaordView.transform = keyBoardOnRight ? CGAffineTransform(translationX: -SCREEN_WIDTH, y: -systemKeyBoardHeight) : CGAffineTransform(translationX: SCREEN_WIDTH, y: -systemKeyBoardHeight)
        // 然后滑动“回到”屏幕内
        let aninations:(() -> Void) = {
            self.keyBoardSnapShotView.transform = self.keyBoardOnRight ? CGAffineTransform(translationX: SCREEN_WIDTH, y: originY) :   CGAffineTransform(translationX: -SCREEN_WIDTH, y: originY)
            self.keyBaordView.transform = CGAffineTransform(translationX: 0, y: -systemKeyBoardHeight)
        }
        UIView.animate(withDuration: TimeInterval(duration), animations: aninations)
        
        keyBoardOnRight = !keyBoardOnRight
        textField.backgroundColor = keyBoardOnRight ? .white : UIColor(hex: "#c4ddff")
    }
}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, self.isOpaque, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
