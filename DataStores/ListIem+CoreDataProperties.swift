//
//  ListIem+CoreDataProperties.swift
//  Remainder
//
//  Created by Dinesh Kumar K K on 17/08/25.
//
//

import Foundation
import CoreData


extension ListIem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListIem> {
        return NSFetchRequest<ListIem>(entityName: "ListIem")
    }

    @NSManaged public var listID: String?
    @NSManaged public var listName: String?
    @NSManaged public var notesIDs: [String]?

}

extension ListIem : Identifiable {

}
