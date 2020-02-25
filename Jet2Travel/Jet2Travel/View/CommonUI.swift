//
//  CommonUI.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation
import UIKit

class CommonUI: NSObject {

    // MARK: - createUIActivityIndicatorView Method
    @objc static func createUIActivityIndicatorView() -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.color = .orange

        return indicator
    }
}
