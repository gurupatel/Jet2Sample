//
//  EmployeeViewController.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblListView: UITableView!

    var listArray: NSMutableArray? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - tableCategory Delegates and Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var value = 0
        
        if (listArray != nil && listArray!.count > 0) {
            
            value = listArray!.count
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"

        let cell: UITableViewCell? = self.tblListView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.selectionStyle = .default

        self.tblListView.separatorStyle = .none

        if (listArray != nil && listArray!.count > 0)  {
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (listArray != nil && listArray!.count > 0) {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let value = UITableView.automaticDimension
        return value
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let rowHeight = UITableView.automaticDimension
//        return rowHeight
//    }
}

