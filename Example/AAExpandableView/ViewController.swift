//
//  ViewController.swift
//  AAExpandableView
//
//  Created by EngrAhsanAli on 03/19/2019.
//  Copyright (c) 2019 EngrAhsanAli. All rights reserved.
//

import UIKit
import AAExpandableView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AAExpandableViewDelegate {

    // MARK: Properties
    @IBOutlet weak var tableView: AAExpandableView!
    var items:[[Int]?] = []
    
    //MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.aa_delegate = self
        
        for i in 0...10 {
            items.append([])
            for j in 0...1 {
                items[i]!.append(j)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.numOfRows(section, datasource: items as Array<AnyObject>)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "section \(indexPath.section) row \(indexPath.row)"
        cell.textLabel?.backgroundColor = .clear
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! HeaderCell
        cell.backgroundColor = cell.contentView.backgroundColor
        return self.tableView.setHeaderView(cell, section: section)

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let vv = self.tableView.sectionHeaderView as? HeaderCell {
            if self.tableView.isOpen(section) {
                vv.titleLabel.text = "Opened"
            }
            else {
                vv.titleLabel.text = "Section \(section), touch here!"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func expandableViewDidOpen(_ view: UIView, section: Int) {
        
    }
    
    func expandableViewDidClose(_ view: UIView, section: Int) {
        
    }
    
}


class HeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
