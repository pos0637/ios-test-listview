//
//  PullToRefreshListView.swift
//  TestListView
//
//  Created by Alex on 2016/10/22.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit
import MJRefresh

/// 下拉刷新列表
@IBDesignable
public class PullToRefreshListView: UITableView {
    public typealias OnRenderCell = (_ cell: UITableViewCell, _ indexPath: IndexPath, _ data: Any?) -> (UITableViewCell)
    public typealias OnFetchComplete = (_ pageId: Int, _ data: [Any?]?, _ options: Any?) -> ()
    public typealias OnFetch = (_ pageId: Int, _ onFetchComplete: @escaping OnFetchComplete, _ options: Any?) -> ()
    
    /// 数据源类型
    public class DataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
        var mRawData: [Any?] = []
        var mOnRenderCell: OnRenderCell!
        
        public func setRawData(_ rawData: [Any?]) {
            mRawData = rawData
        }
        
        public func appendData(_ rawData: [Any?]) {
            mRawData += rawData
        }
        
        public func setOnRenderCell(_ onRenderCell: @escaping OnRenderCell) {
            mOnRenderCell = onRenderCell
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.mRawData.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
            if mOnRenderCell != nil {
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell = mOnRenderCell(cell, indexPath, mRawData[indexPath.row])
            }
            
            return cell
        }
    }
    
    fileprivate var mDataSource: DataSource = DataSource()
    fileprivate var mOnFetch: OnFetch?
    fileprivate var mCurrentPage: Int = 0

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        ctor()
    }
    
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        ctor()
    }
    
    func ctor() {
        delegate = mDataSource
        dataSource = mDataSource
    }

    /// 初始化
    ///
    /// - parameter cellClass:     单元格类型
    /// - parameter pullToRefresh: 是否下拉刷新
    /// - parameter loadMore:      是否上拉加载
    /// - parameter rawData:       源数据
    /// - parameter onRenderCell:  渲染单元格处理函数
    /// - parameter onFetch:       获取数据处理函数
    public func initialize(
        _ cellClass: Swift.AnyClass = UITableViewCell.self,
        _ pullToRefresh: Bool = true,
        _ loadMore: Bool = true,
        _ firstLoad: Bool = true,
        _ rawData: [Any?] = [],
        _ onRenderCell: @escaping OnRenderCell,
        _ onFetch: @escaping OnFetch)
    {
        register(cellClass, forCellReuseIdentifier: "cell")
        mOnFetch = onFetch
        mDataSource.setRawData(rawData)
        mDataSource.setOnRenderCell(onRenderCell)
     
        if pullToRefresh {
            self.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(PullToRefreshListView.refreshData))
        }
        
        if loadMore {
            self.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(PullToRefreshListView.loadMore))
        }
        
        if firstLoad {
            self.mj_header.beginRefreshing()
        }
    }
    
    /// 刷新数据
    ///
    /// - parameter sender: 组件
    func refreshData(_ sender: MJRefreshComponent){
        if mOnFetch == nil {
            self.mj_header.endRefreshing()
            self.mj_footer.state = MJRefreshState.idle
            return
        }
        
        mCurrentPage = 1;
        
        mOnFetch!(
            mCurrentPage,
            {(pageId, data, options) -> () in
                let rawData = data != nil ? data!: []
                self.mDataSource.setRawData(rawData)
                self.mCurrentPage += 1

                self.mj_header.endRefreshing()
                self.mj_footer.state = MJRefreshState.idle
                self.reloadData()
            },
            nil)
    }
    
    /// 加载更多
    ///
    /// - parameter sender: 组件
    func loadMore(_ sender: MJRefreshComponent) {
        if mOnFetch == nil {
            self.mj_footer.endRefreshing()
            self.mj_footer.state = MJRefreshState.noMoreData
            return
        }
        
        mOnFetch!(
            mCurrentPage,
            {(pageId, data, options) -> () in
                let rawData = data != nil ? data!: []
                self.mDataSource.appendData(rawData)
                self.mCurrentPage += 1
                
                self.mj_footer.endRefreshing()
                self.mj_footer.state = data != nil ? MJRefreshState.idle: MJRefreshState.noMoreData
                self.reloadData()
            },
            nil)
    }
}
