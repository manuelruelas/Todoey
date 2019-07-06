//
//  Category.swift
//  Todoey
//
//  Created by Jorge Guzman on 7/4/19.
//  Copyright © 2019 Indq. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
