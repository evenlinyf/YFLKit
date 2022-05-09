//
//  YFLPagingLoad.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation

public class YFLPagingLoad: NSObject {
    
    public enum Status {
        case empty
        case canLoadMore
        case loadAll
    }
    
    public var isRefresh = true {
        didSet {
            isRefresh ? (page = firstPage) : (page += 1)
        }
    }
    
    public var status: Status = .empty
    
    /// 第一页, 0 或者 1, 看接口
    private var firstPage: Int = 0 {
        didSet {
            page = firstPage
        }
    }
    
    /// 第几页 默认第0页
    public var page: Int = 0
    
    /// 每页多少个 默认15
    public var size: Int = 15
    
    public convenience init(page: Int, size: Int) {
        self.init()
        self.firstPage = page
        self.size = size
    }
    
    /// 设置返回的Models
    public func setModels<T>(models: inout [T], with sModels: [T]) {
        self.status = sModels.count < size ? (sModels.count == 0 ? (isRefresh ? .empty : .loadAll) : .loadAll) : .canLoadMore
        isRefresh ? (models = sModels) : (models += sModels)
    }
    
    /// 重置为未请求的状态
    public func resetToUnreq() {
        if isRefresh == false && page > firstPage {
            page -= 1
        } else {
            page = firstPage
        }
    }
}
