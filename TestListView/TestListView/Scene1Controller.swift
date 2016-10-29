//
//  Scene1Controller.swift
//  TestListView
//
//  Created by Alex on 2016/10/25.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class Scene1Controller: UIViewController {
    
    @IBOutlet weak var mListView: PullToRefreshListView?
 
    var mA : Int = 0
    
    override func viewDidLoad() {
        if mListView == nil {
            return
        }
            
        mListView!.initialize(
            UITableViewCell.self,
            true,
            true,
            false,
            [],
            {(cell, indexPath, data) -> UITableViewCell in
                var content = data != nil ? (data as! String): ""
                content += "\(self.mA)"
                self.mA += 1
                
                cell.textLabel?.text = content
                return cell
            },
            {(pageId, onFetchComplete, options) -> () in
                var rawData: [String] = []
                for i in 1...3 {
                    rawData.append("第\(i)条数据")
                }
                
                onFetchComplete(pageId, rawData, options)
            })
    }
}
