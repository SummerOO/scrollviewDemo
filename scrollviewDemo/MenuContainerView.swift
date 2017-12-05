//
//  MenuContainerView.swift
//  scrollviewDemo
//
//  Created by zr on 2017/12/1.
//  Copyright © 2017年 ZR. All rights reserved.
//

import UIKit

class MenuContainerView: UIView {
    
    open var showPage: CGFloat = 2
    var menus: [UIButton] = [UIButton]()
    var views: [UIView] = [UIView]()
    var itemColor = UIColor.black
    var indicatorColor = UIColor.blue {
        didSet {
            indicatorView.backgroundColor = indicatorColor
        }
    }
    
    init(frame: CGRect, menus: [UIButton], views: [UIView]) {
        super.init(frame: frame)
        if menus.count != views.count {
            fatalError("menus.count != viewControllers.count")
        }
        self.menus = menus
        self.views = views
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private var scrollView: UIScrollView!
    
    private var itemsTitle: [String] = [String]()
    private var viewsFrame: [CGRect] = [CGRect]()
    fileprivate var itemsOriginX: [CGFloat] = [CGFloat]()
    
    fileprivate var indicatorView: UIView!
    fileprivate var bottomLineView: UIView!

    fileprivate var indicatorViewLastOriginX: CGFloat = 0.0 {
        didSet {
            indicatorCopyView.frame.origin.x = indicatorViewLastOriginX
        }
    }
    fileprivate let indicatorViewWidth: CGFloat = 130
    
    fileprivate var scale: CGFloat!
    
    fileprivate let moveDuration: TimeInterval = 0.2
    fileprivate var indicatorCopyView: UIView!
    fileprivate var shouldAdjustCopyIndicatorView = false

    func buildUI() {

        scrollView = UIScrollView()
        let customTitleView = UIView()
        
        let titleStackView = OAStackView()
        
        indicatorView = UIView()
        indicatorCopyView = UIView()
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        bottomLineView = UIView()
        bottomLineView.backgroundColor = .gray
        
        for button in menus {
            button.setTitleColor(itemColor, for: .normal)
            itemsTitle.append(button.currentTitle!)
        }
        
        customTitleView.backgroundColor = UIColor.white
        for item in menus {
            titleStackView.addArrangedSubview(item)
        }
        titleStackView.alignment = .center
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        
        for i in 0 ..< views.count {
            let subvc = views[i]
            self.addSubview(subvc)
            scrollView.addSubview(subvc)
            subvc.didMoveToSuperview()
        }
        
        let titleViewWidth: CGFloat = self.frame.width
        let titleViewHeight: CGFloat = 44
        let stackViewHeight: CGFloat = 40
        
        let titleViewFrame = CGRect(x: 0, y: 0, width: titleViewWidth, height: titleViewHeight)
        let stackViewFrame = CGRect(x: 0, y: 0, width: titleViewWidth, height: stackViewHeight)
        let indicatorViewFrame = CGRect(x: 0, y: titleViewHeight - 2, width: indicatorViewWidth, height: 2)
        
        customTitleView.frame = titleViewFrame
        customTitleView.frame.origin.x = self.frame.midX - titleViewWidth/2
        
        titleStackView.frame = stackViewFrame
        
        indicatorView.frame = indicatorViewFrame
        indicatorView.backgroundColor = indicatorColor
        
        // for menuItems originX
        var itemOriginX: CGFloat = 0
        print(showPage)
        let itemWidth: CGFloat = titleViewWidth / showPage
        for item in menus {
            item.addTarget(self, action: #selector(contentOffSetXForButton), for: .touchUpInside)
            let itemFrame = CGRect(x: itemOriginX, y: 0, width: itemWidth, height: stackViewHeight)
            item.frame = itemFrame
            let indicatorOriginX = itemFrame.midX - indicatorViewWidth/2
            itemsOriginX.append(indicatorOriginX)
            itemOriginX += itemWidth
        }
        
        // for sectionIndicatorView
        indicatorView.frame.origin.x = itemsOriginX[0]
        indicatorViewLastOriginX = indicatorView.frame.origin.x
        
        // indicator copy view
        indicatorCopyView.frame = indicatorView.frame
        indicatorCopyView.backgroundColor = indicatorView.backgroundColor
        indicatorCopyView.isHidden = true
        
        // indicator scroll scale
        var indicatorScale: CGFloat
        if showPage > 1 {
            indicatorScale = itemsOriginX[1] - itemsOriginX[0]
        } else {
            indicatorScale = itemsOriginX[0]
        }
        scale = indicatorScale / UIScreen.main.bounds.size.width
        bottomLineView.frame = CGRect(x: 0, y: titleViewHeight - 2, width: self.frame.width, height: 1)
        customTitleView.addSubview(bottomLineView)
        customTitleView.addSubview(titleStackView)
        customTitleView.addSubview(indicatorView)
        customTitleView.addSubview(indicatorCopyView)
        self.addSubview(customTitleView)
        
        self.addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildUI()
        let scrollViewFrame = self.frame

        scrollView.frame = CGRect(x: 0, y: 50, width: self.frame.width, height: self.frame.height)
        
        let width = scrollViewFrame.width
        let height = scrollViewFrame.height
        scrollView.contentSize = CGSize(width: width * showPage, height: height)
        
        // has [viewFrame]
        var vcOriginX: CGFloat = 0
        for _ in 0 ..< views.count {
            viewsFrame.append(CGRect(x: vcOriginX, y: 0, width: width, height: height))
            vcOriginX += width
        }
        
        for i in 0 ..< views.count {
            views[i].frame = viewsFrame[i]
        }
        menus.first?.isSelected = true
    }
    
    @objc private func contentOffSetXForButton(sender: UIButton){
        let currentTitle = sender.currentTitle!
        let index = itemsTitle.index(of: currentTitle)!

        for (i, btn) in menus.enumerated() {
            if i == index {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        scrollView.setContentOffset(viewsFrame[index].origin, animated: true)
        UIView.animate(withDuration: moveDuration, animations: {
            self.indicatorView.frame.origin.x = self.itemsOriginX[index]
            self.indicatorViewLastOriginX = self.indicatorView.frame.origin.x
        })
    }
}

extension MenuContainerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xx = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(xx/w))
        for (i, btn) in menus.enumerated() {
            if i == currentPage  {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        UIView.animate(withDuration: moveDuration, animations: {
            let x = scrollView.contentOffset.x * self.scale + self.itemsOriginX[0]
            self.indicatorView.frame.origin.x = x
            self.indicatorViewLastOriginX = x
            
        })
    }
}
