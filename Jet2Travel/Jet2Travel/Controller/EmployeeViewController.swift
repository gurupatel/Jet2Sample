//
//  EmployeeViewController.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedRow = 0
    
    var indicator: UIActivityIndicatorView!

    @IBOutlet var tblListView: UITableView!

    var arrEmpDataEntity : [EmployeeData]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tblListView.rowHeight = UITableView.automaticDimension
        self.tblListView.estimatedRowHeight = 80; //Set this to any value that works for you.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
        //Check for internet connection
        if (Constants.isConnectedToInternet() == true) {
            
            //Added loader till api respond
            self.addIndicator()
            
            //Get employee data from server
            self.getEmployeeDataFromServer()
        }
        else {
            
            //No internet connection show old fetched data, if any.
         
            let employeeData = UserDefaults.standard.array(forKey: "EmployeeData")

            if (employeeData != nil) {
                
                arrEmpDataEntity = EmployeeParser.parseEmployeeData(dataArray: employeeData)

                self.reLoadTableView()
            }
        }
    }
    
    // MARK: - Button Action Method
    
    @IBAction func sortByNameBtnBackTapped(_ sender: Any?) {
                
        arrEmpDataEntity = arrEmpDataEntity!.sorted { ($0.empName!).localizedCaseInsensitiveCompare($1.empName!) == ComparisonResult.orderedAscending }

        self.reLoadTableView()
    }
    
    @IBAction func sortByAgeBtnBackTapped(_ sender: Any?) {

        arrEmpDataEntity = arrEmpDataEntity!.sorted { ($0.empAge!).localizedCaseInsensitiveCompare($1.empAge!) == ComparisonResult.orderedAscending }

        self.reLoadTableView()
    }

    // MARK: - reLoadTableView Method

    func reLoadTableView() {
        
        self.tblListView.reloadData()
    }
    
    // MARK: - getEmployeeDataFromServer Method

    func getEmployeeDataFromServer() {
        
        let webServices = WebServices()
        
        webServices.getEmployeeData(completion: { (reponse, error) in
        
            self.removeIndicator()

            if (error != nil) {
                
                //Error
            }
            else {
                
                //API Success
                
                if (reponse != nil) {
                  
                    if (reponse!["status"] as? String ?? "" == "success") {
                        
                        //Success
                        
                        let data = reponse!["data"] as? NSArray
                        
                        if (data != nil && (data?.count)! > 0) {
                            
                            UserDefaults.standard.set(reponse!["data"] as? Array<Any>, forKey: "EmployeeData")
                            
                            self.arrEmpDataEntity = EmployeeParser.parseEmployeeData(dataArray: reponse!["data"] as? Array)

                            self.reLoadTableView()
                        }
                    }
                    else {
                        
                        //Error
                    }
                }
            }
        })
    }
    
    // MARK: - tableCategory Delegates and Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var value = 0
        
        if (arrEmpDataEntity != nil && arrEmpDataEntity!.count > 0) {
            
            value = arrEmpDataEntity!.count
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDataCell", for: indexPath) as! EmployeeDataCell

        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator

        if (arrEmpDataEntity != nil && arrEmpDataEntity!.count > 0)  {
            
            let empData = arrEmpDataEntity![indexPath.row]
            
            //Shwoing data in cells
            cell.lblEmpName.text = "Name : " + empData.empName!
            cell.lblEmpAge.text = "Age : " + empData.empAge!
            cell.empImg!.sd_setImage(with: URL(string: empData.empImgLink!), placeholderImage: UIImage(named: Constants.employeePlaceHolder))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (arrEmpDataEntity != nil && arrEmpDataEntity!.count > 0) {
            
            //Storing selected index to pass data to detail screen
            selectedRow = indexPath.row
            
            //Adding EmployeeDetails controller
            performSegue(withIdentifier: "ShowEmployeeDetails", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        //For right swipe to delete user data
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            if (arrEmpDataEntity != nil && arrEmpDataEntity!.count > 0) {
            
                arrEmpDataEntity?.remove(at: indexPath.row)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Passing selected employee data to another screen
       let destVC : EmployeeDetailsController = segue.destination as! EmployeeDetailsController
       destVC.empDataEntity = arrEmpDataEntity![selectedRow]
    }
}

