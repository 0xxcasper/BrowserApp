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
    dynamic var name = ""
    dynamic var time = Date()

    override static func primaryKey() -> String? {
        return HistoryModel.Property.id.rawValue
    }
    
    convenience init(_ url: String, _ name: String,_ time: Date) {
        self.init()
        self.url = url
        self.name = name
        self.time = time
    }
}

extension HistoryModel {
    static func add(url: String, name: String, time: Date,in realm: Realm = try! Realm()) -> HistoryModel {
        let history = HistoryModel(url, name, time)
        try! realm.write {
            realm.add(history)
        }
        return history
    }
    
    static func getAll(in realm: Realm = try! Realm()) -> [HistoryModel] {
        return realm.objects(HistoryModel.self).sorted { (history1, history2) -> Bool in
            return history1.time > history2.time
        }
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }
}
