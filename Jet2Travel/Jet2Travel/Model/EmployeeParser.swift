//
//  EmployeeParser.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation

// MARK: - EmployeeParser

class EmployeeParser: NSObject {

    // MARK: - parseEmployeeData

    static func parseEmployeeData(dataArray : Array<Any>?) -> [EmployeeData] {

        var arrEmployeeDataEntity: [EmployeeData] = []

        if (dataArray != nil) {
            
            for i in 0..<dataArray!.count {

                let employeeDataEntity = EmployeeData()
                
                if let employeeDataDict  = dataArray![i] as? NSDictionary
                {
                    employeeDataEntity.empName = (employeeDataDict["employee_name"] as? String ?? "")
                    employeeDataEntity.empID = (employeeDataDict["id"] as? String ?? "")
                    employeeDataEntity.empAge = (employeeDataDict["employee_age"] as? String ?? "")
                    employeeDataEntity.empSalary = (employeeDataDict["employee_salary"] as? String ?? "")
                    employeeDataEntity.empImgLink = (employeeDataDict["profile_image"] as? String ?? "")

                    arrEmployeeDataEntity.append(employeeDataEntity)
                }
            }
        }
        
        return arrEmployeeDataEntity
    }
}
