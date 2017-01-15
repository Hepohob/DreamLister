//
//  MaterialView.swift
//  DreamLister
//
//  Created by Aleksei Neronov on 15.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {

    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        }
        set {
            materialKey = newValue
        }
    }

}
