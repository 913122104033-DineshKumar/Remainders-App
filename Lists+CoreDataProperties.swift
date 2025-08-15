//
//  Lists+CoreDataProperties.swift
//  Remainder
//
//  Created by Dinesh Kumar K K on 15/08/25.
//
//

import Foundation
import CoreData


extension Lists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lists> {
        return NSFetchRequest<Lists>(entityName: "Lists")
    }

    @NSManaged public var listID: String?

}

extension Lists : Identifiable {

}
