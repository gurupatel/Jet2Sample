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

    var arrEmployeeDataEntity : [EmployeeData]? = nil

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
    
    // MARK: - Button Action Method
    
    @IBAction func sortByNameBtnBackTapped(_ sender: Any?) {
                
        arrEmployeeDataEntity = arrEmployeeDataEntity!.sorted { ($0.empName!).localizedCaseInsensitiveCompare($1.empName!) == ComparisonResult.orderedAscending }

        self.reLoadTableView()
    }
    
    @IBAction func sortByAgeBtnBackTapped(_ sender: Any?) {

        arrEmployeeDataEntity = arrEmployeeDataEntity!.sorted { ($0.empAge!).localizedCaseInsensitiveCompare($1.empAge!) == ComparisonResult.orderedAscending }

        self.reLoadTableView()
    }

    // MARK: - reLoadTableView Method

    func reLoadTableView() {
        
        self.tblListView.reloadData()
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
                
                arrEmployeeDataEntity = EmployeeParser.parseEmployeeData(dataArray: responseDict!["data"] as? Array)

                self.reLoadTableView()
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
        
        if (arrEmployeeDataEntity != nil && arrEmployeeDataEntity!.count > 0) {
            
            value = arrEmployeeDataEntity!.count
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDataCell", for: indexPath) as! EmployeeDataCell

        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator

        if (arrEmployeeDataEntity != nil && arrEmployeeDataEntity!.count > 0)  {
            
            let empData = arrEmployeeDataEntity![indexPath.row]
            
            cell.lblEmpName.text = "Name : " + empData.empName!
            cell.lblEmpAge.text = "Age : " + empData.empAge!
            
            cell.empImg!.sd_setImage(with: URL(string: empData.empImgLink!), placeholderImage: UIImage(named: Constants.employeePlaceHolder))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (arrEmployeeDataEntity != nil && arrEmployeeDataEntity!.count > 0) {
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            if (arrEmployeeDataEntity != nil && arrEmployeeDataEntity!.count > 0) {
            
                arrEmployeeDataEntity?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
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

