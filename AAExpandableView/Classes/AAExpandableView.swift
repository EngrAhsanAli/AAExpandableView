//
//  AAExpandableView.swift
//  AAExpandableView
//
//  Created by Ahsan Ali on 11/03/19.
//  Copyright (c) 2019 AA-Creations. All rights reserved.
//

import UIKit

public protocol AAExpandableViewDelegate: NSObjectProtocol {
    func expandableViewDidOpen(_ section:Int)
    func expandableViewDidClose(_ section:Int)
}

open class AAExpandableView : UITableView, AAHeaderViewDelegate {
    
    open var sectionOpen: Int = NSNotFound
    open var aa_delegate: AAExpandableViewDelegate?

    // MARK: AAExpandableViewDelegate
    public func accordionViewDidOpen(_ section: Int) {
        
        if self.sectionOpen != NSNotFound {
            accordionViewDidClose(self.sectionOpen)
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
        
        aa_delegate?.expandableViewDidOpen(section)
    }
    
    open func shouldOpen(_ section: Int) -> Bool {
        return (sectionOpen != NSNotFound && section == sectionOpen)
    }
    
    public func accordionViewDidClose(_ section: Int) {
        
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
        
        aa_delegate?.expandableViewDidClose(section)
    }
    
    open func setHeaderView(_ headerView: UIView, section:Int) -> UIView {
        return AAHeaderView(tableView: self, headerView: headerView, section: section)
    }
}
