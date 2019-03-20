//
//  AAExpandableView.swift
//  AAExpandableView
//
//  Created by Ahsan Ali on 11/03/19.
//  Copyright (c) 2019 AA-Creations. All rights reserved.
//

import UIKit

public protocol AAExpandableViewDelegate: NSObjectProtocol {
    func expandableViewDidOpen(_ view: UIView, section:Int)
    func expandableViewDidClose(_ view: UIView, section:Int)
}

open class AAExpandableView : UITableView, AAHeaderViewDelegate {
    
    open var sectionOpen: Int = NSNotFound
    open var aa_delegate: AAExpandableViewDelegate?
    open var refreshChange: RowAnimation? = .automatic
    var sectionView: AAHeaderView?

    open var sectionHeaderView: UIView? {
        return sectionView?.headerView
    }
    
    // MARK: AAExpandableViewDelegate
    public func didOpen(_ section: Int) {
        
        if self.sectionOpen != NSNotFound {
            didClose(self.sectionOpen)
        }
        
        self.sectionOpen = section
        let numberOfRows = self.dataSource?.tableView(self, numberOfRowsInSection: section)
        var indexesPathToInsert:[IndexPath] = []
        
        for i in 0..<numberOfRows! {
            indexesPathToInsert.append(IndexPath(row: i, section: section))
        }
        
        if indexesPathToInsert.count > 0 {
            self.beginUpdates()
            self.insertRows(at: indexesPathToInsert, with: .automatic)
            self.endUpdates()
        }
        
        let headerView = self.delegate?.tableView!(self, viewForHeaderInSection: section) as! AAHeaderView
        aa_delegate?.expandableViewDidOpen(headerView.headerView, section: section)
        refreshChangedSection(section)
    }
    
    func refreshChangedSection(_ section: Int) {
        guard let anim = refreshChange else { return }
        self.reloadSections(IndexSet(integer: section), with: anim)
    }
    
    open func isOpen(_ section: Int) -> Bool {
        return (sectionOpen != NSNotFound && section == sectionOpen)
    }
    
    public func didClose(_ section: Int) {
        
        let numberOfRows = self.dataSource?.tableView(self, numberOfRowsInSection: section)
        var indexesPathToDelete: [IndexPath] = []
        self.sectionOpen = NSNotFound
        
        for i in 0..<numberOfRows! {
            indexesPathToDelete.append(IndexPath(row: i, section: section))
        }
        
        if indexesPathToDelete.count > 0 {
            self.beginUpdates()
            self.deleteRows(at: indexesPathToDelete, with: .top)
            self.endUpdates()
        }
        
        let headerView = self.delegate?.tableView!(self, viewForHeaderInSection: section) as! AAHeaderView
        aa_delegate?.expandableViewDidClose(headerView.headerView, section: section)
        refreshChangedSection(section)
    }
    
    open func setHeaderView(_ headerView: UIView, section:Int) -> UIView {
        self.sectionView = AAHeaderView(tableView: self, headerView: headerView, section: section)
        return self.sectionView!
    }
    
    open func numOfRows(_ section: Int, datasource: Array<AnyObject>) -> Int {
        if (!datasource.isEmpty) {
            if self.isOpen(section) {
                return datasource[section].count
            }
        }
        return 0
    }
}
