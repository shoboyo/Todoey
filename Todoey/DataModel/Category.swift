//
//  Category.swift
//  Todoey
//
//  Created by Raileanu Razvan Andrei on 19/11/2018.
//  Copyright © 2018 MetaLanguage. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
