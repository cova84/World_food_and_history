//
//  Favorite+CoreDataProperties.swift
//  
//
//  Created by 小林由知 on 2017/12/12.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var country: String?
    @NSManaged public var hotel: String?
    @NSManaged public var id: Int16

}
