//
//  AttributesViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 2018/4/20.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height

class AttributesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRoles()
    }
    
    func loadRoles() {
        let imageView = UIImageView()
        let image = UIImage(named: "friendstore_attributes")
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH * (image?.size.height)! / (image?.size.width)!)
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }
}

