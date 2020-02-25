//
//  EmployeeData.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation

// MARK: - EmployeeData

class EmployeeData: NSObject {
  
    // MARK: - Variables And Properties
    
    var empName: String
    var empSalary: String
    var empAge: String
    var empImg: String
  
    // MARK: - Initialization

    init(empName: String, empSalary: String, empAge: String, empImg: String) {
    self.empName = empName
    self.empSalary = empSalary
    self.empAge = empAge
    self.empImg = empImg
  }
}
