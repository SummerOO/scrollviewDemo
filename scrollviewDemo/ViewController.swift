//
//  ViewController.swift
//  scrollviewDemo
//
//  Created by zr on 2017/11/30.
//  Copyright © 2017年 ZR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var showCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    func buildUI() {
        let frame = CGRect(x: 0, y: 300, width: 375, height: 300)
        let menusView = MenuContainerView(frame: frame, menus: pageItems(), views: pageViewContorllers())
        menusView.showPage = CGFloat(showCount)
        self.view.addSubview(menusView)
    }
    
    private func pageItems() -> [UIButton] {
        
        var items = [UIButton]()
        
        let red = UIButton()
        let gray = UIButton()
        let purple = UIButton()
        
        red.setTitle("One", for: .normal)
        gray.setTitle("Two", for: .normal)
        purple.setTitle("Three", for: .normal)
        red.setTitleColor(UIColor.gray, for: .normal)
        red.setTitleColor(UIColor.red, for: .selected)
        gray.setTitleColor(UIColor.gray, for: .normal)
        gray.setTitleColor(UIColor.red, for: .selected)
        purple.setTitleColor(UIColor.gray, for: .normal)
        purple.setTitleColor(UIColor.red, for: .selected)
        items.append(red)
        items.append(gray)
        items.append(purple)
        var btnArray: [UIButton] = [UIButton]()
        for i in items[0...showCount - 1] {
            btnArray.append(i)
        }
        return btnArray
    }
    
    private func pageViewContorllers() -> [UIView] {
        
        var vcs = [UIView]()
        
        let fristView = UIView()
        fristView.backgroundColor = .red
        
        let secondView = UIView()
        secondView.backgroundColor = .blue
        
        let thirdView = UIView()
        thirdView.backgroundColor = .gray
        
        vcs.append(fristView)
        vcs.append(secondView)
        vcs.append(thirdView)
        var viewArray: [UIView] = [UIView]()
        for i in vcs[0...showCount - 1] {
            viewArray.append(i)
        }
        return viewArray
    }
}

