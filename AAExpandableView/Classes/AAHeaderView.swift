//
//  AAHeaderView.swift
//  AAAccordionView
//
//  Created by Ahsan Ali on 11/03/19.
//  Copyright (c) 2019 AA-Creations. All rights reserved.
//

import UIKit

protocol AAHeaderViewDelegate: NSObjectProtocol {
    func didOpen(_ section:Int)
    func didClose(_ section:Int)
}

class AAHeaderView: UIView {
    
    var delegate: AAHeaderViewDelegate?
    var section: Int!
    var tableView: AAExpandableView!
    var headerView: UIView!
    
    required public init(tableView: AAExpandableView, headerView: UIView, section:Int) {
        
        let height = tableView.delegate!.tableView!(tableView, heightForHeaderInSection: section)
 
        
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: height)
        
        super.init(frame: frame)
        
        self.tableView = tableView
        self.delegate = tableView
        self.section = section
        
        if #available(iOS 11, *) {
            self.tableView.estimatedRowHeight = 0
            self.tableView.estimatedSectionHeaderHeight = 0
            self.tableView.estimatedSectionFooterHeight = 0
        }
        
        headerView.frame = self.frame
        self.headerView = headerView
        backgroundColor = .clear
        addSubview(self.headerView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(btn)
    }
    
    @objc func toggle() {
        
        if self.tableView.sectionOpen != section {
            self.delegate?.didOpen(section)
        } else if self.tableView.sectionOpen != NSNotFound {
            self.delegate?.didClose(self.tableView.sectionOpen)
        }
    }
}
