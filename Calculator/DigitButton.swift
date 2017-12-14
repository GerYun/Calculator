//
//  DigitButton.swift
//  Calculator
//
//  Created by weiwu du on 2017/12/13.
//  Copyright © 2017年 suning. All rights reserved.
//

import UIKit

class DigitButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height * 0.5
        layer.masksToBounds = true
    }

}
