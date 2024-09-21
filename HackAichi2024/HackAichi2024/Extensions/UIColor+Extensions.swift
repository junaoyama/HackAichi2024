//
//  UIColor.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/21.
//

import UIKit

extension UIColor {
    class var vcBackground: UIColor {
        return UIColor(named: "viewControllerBackground")!
    }
    
    class var cellBackground: UIColor {
        return UIColor(named: "messageCellBackground")!
    }
    
    class var cellText: UIColor {
        return UIColor(named: "messageCellText")!
    }
    
    class var userCellBorder: UIColor {
        return UIColor(named: "userMessageCellBorder")!
    }
    
    class var characterCellBorder: UIColor {
        return UIColor(named: "characterMessageCellBorder")!
    }
}
