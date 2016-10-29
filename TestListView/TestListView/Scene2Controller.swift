//
//  Scene2Controller.swift
//  TestListView
//
//  Created by Alex on 2016/10/29.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Scene2Controller: ButtonBarPagerTabStripViewController {
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = blueInstagramColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.blueInstagramColor
        }
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let subView1 = SubView1Controller(nibName: "SubView1", bundle: nil)
        subView1.setItemInfo(IndicatorInfo(title: " SubView1"))
        
        let subView2 = SubView1Controller(nibName: "SubView2", bundle: nil)
        subView2.setItemInfo(IndicatorInfo(title: " SubView2"))
        
        return [subView1, subView2]
    }
}
