//
//  MovieAppConstants.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import Foundation
import UIKit

enum ShowingType {
    case grid
    case list
    
    mutating func toggle() {
        if self == .grid {
            self = .list
            
        } else {
            self = .grid
        }
    }
    
    var icon: UIImage? {
        get {
            switch self {
            case .grid:
                return UIImage(named: "grid")
            case .list:
                return UIImage(named: "list")
            }
        }
    }
}


