//
//  SubView1Controller.swift
//  TestListView
//
//  Created by Alex on 2016/10/29.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SubView1Controller: UIViewController, IndicatorInfoProvider {
    
    var mItemInfo = IndicatorInfo(title: "unknown")
    
    public func setItemInfo(_ info: IndicatorInfo!) {
        mItemInfo = info
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return mItemInfo
    }
}
