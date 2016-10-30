//
//  Scene4Controller.swift
//  TestListView
//
//  Created by Alex on 2016/10/29.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class Scene4Controller: UIViewController {
    
    @IBOutlet weak var mListView: PullToRefreshGridView?
    
    var mA : Int = 0
    
    override func viewDidLoad() {
        if mListView == nil {
            return
        }
        
        mListView!.initialize(
            UICollectionViewCell.self,
            true,
            true,
            false,
            [],
            {(cell, indexPath, data) -> UICollectionViewCell in
                var content = data != nil ? (data as! String): ""
                content += "\(self.mA)"
                self.mA += 1
                
                cell.backgroundColor = .red
                return cell
        },
            {(pageId, onFetchComplete, options) -> () in
                var rawData: [String] = []
                for i in 1...30 {
                    rawData.append("第\(i)条数据")
                }
                
                onFetchComplete(pageId, rawData, options)
        })
    }
}
