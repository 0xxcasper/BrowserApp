//
//  HistoryModel.swift
//  BrowserApp
//
//  Created by SangNX on 11/25/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class HistoryModel: Object {
    enum Property: String {
        case id, url
    }
    
    dynamic var id = UUID().uuidString
    dynamic var url = ""
    
    override static func primaryKey() -> String? {
        return HistoryModel.Property.id.rawValue
    }
    
    convenience init(_ url: String) {
        self.init()
        self.url = url
    }
}


extension HistoryModel {
    static func add(url: String, in realm: Realm = try! Realm()) -> HistoryModel {
        let history = HistoryModel(url)
        try! realm.write {
            realm.add(history)
        }
        return history
    }
    
    static func getAll(in realm: Realm = try! Realm()) -> Results<HistoryModel> {
        return realm.objects(HistoryModel.self)
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }
}
