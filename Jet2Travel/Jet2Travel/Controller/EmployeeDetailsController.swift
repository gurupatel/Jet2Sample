//
//  EmployeeDetailsController.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 26/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation

import UIKit

class EmployeeDetailsController: UIViewController {

    var empDataEntity : EmployeeData? = nil
   
    @IBOutlet weak var lblEmpAge: UILabel!
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblEmpSalary: UILabel!
    @IBOutlet weak var empImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (empDataEntity != nil) {
            
            lblEmpAge.text = "Age : " + empDataEntity!.empAge!
            lblEmpName.text = "Name : " + empDataEntity!.empName!
            lblEmpSalary.text = "Salary : " + empDataEntity!.empSalary!
                
            //We can also use following line to show Salary, this will show Salary in formatted form
            //Int(empDataEntity!.empSalary!)!.withCommas()
            
            empImg!.sd_setImage(with: URL(string: empDataEntity!.empImgLink!), placeholderImage: UIImage(named: Constants.employeePlaceHolder))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

    }
    
    // MARK: - Button Action Method
    
    @IBAction func closeBtnBackTapped(_ sender: Any?) {
        
        dismiss(animated: true, completion: nil)
    }
}

//The following method will show Salary in formatted form

extension Int {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
