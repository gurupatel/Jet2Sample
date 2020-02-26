//
//  EmployeeViewController.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeDataModelClassDelegate {

    var indicator: UIActivityIndicatorView!

    @IBOutlet var tblListView: UITableView!

    var employeeDataEntity : [EmployeeData]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
        //Check for internet connection
        if (Constants.isConnectedToInternet() == true) {
            
            self.addIndicator()
            
            self.getEmployeeDataFromServer()
        }
        else {
            
            //No internet connection
            
        }
    }
    
    // MARK: - getEmployeeDataFromServer Method

    func getEmployeeDataFromServer() {
        
        let webServices = WebServices()
        webServices.delegate = self
        webServices.getEmployeeData()
    }
    
    // MARK: - EmployeeData Delegates Methods

    func didGetEmployeeDataSuccessfully(_ responseDict: NSDictionary?) {
        
        self.removeIndicator()
        
        if (responseDict!["status"] as? String ?? "" == "success") {
            
            //Success
            
            let data = responseDict!["data"] as? NSArray
            
            if (data != nil && (data?.count)! > 0) {
                
                employeeDataEntity = EmployeeParser.parseEmployeeData(dataArray: responseDict!["data"] as? Array)

                self.tblListView.reloadData()
            }
        }
        else {
            
            //Error
        }
    }
    
    func didGetEmployeeDataFailed(_ error: Error?) {
        
        self.removeIndicator()
    }

    // MARK: - tableCategory Delegates and Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var value = 0
        
        if (employeeDataEntity != nil && employeeDataEntity!.count > 0) {
            
            value = employeeDataEntity!.count
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDataCell", for: indexPath) as! EmployeeDataCell

        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator

        if (employeeDataEntity != nil && employeeDataEntity!.count > 0)  {
            
            let empData = employeeDataEntity![indexPath.row]
            
            cell.lblEmpName.text = "Name : " + empData.empName!
            cell.lblEmpAge.text = "Age : " + empData.empAge!
            
            cell.empImg!.sd_setImage(with: URL(string: empData.empImgLink!), placeholderImage: UIImage(named: Constants.employeePlaceHolder))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (employeeDataEntity != nil && employeeDataEntity!.count > 0) {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let value = UITableView.automaticDimension
        return value
    }
    
    // MARK: - addIndicator
    func addIndicator() {
    
        /* Adding UIActivityIndicatorView to view */
        indicator = CommonUI.createUIActivityIndicatorView()
        indicator.center = self.view.center

        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        
        indicator.startAnimating()
    }
    
    // MARK: - removeIndicator
    func removeIndicator() {

        indicator.stopAnimating()
        
        indicator.removeFromSuperview()
    }
}

