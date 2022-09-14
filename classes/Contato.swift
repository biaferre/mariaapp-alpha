//
//  Contato.swift
//  marIA
//
//  Created by Bof on 29/04/22.
//  Copyright © 2022 marIA. All rights reserved.
//

import Foundation
import UIKit

class Contato {
    var num: Int!
    var name: String!
    
    init() {
        self.num = 0
        self.name = ""
    }
    
    func addInfo (_ name: String!, _ num: Int!) {
        self.name = name
        self.num = num
    }
}
