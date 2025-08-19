//
//  Notes+CoreDataProperties.swift
//  Remainder
//
//  Created by Dinesh Kumar K K on 18/08/25.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var notesID: String?
    @NSManaged public var notes: String?
    @NSManaged public var notesTitle: String?
    @NSManaged public var listID: String?

}
