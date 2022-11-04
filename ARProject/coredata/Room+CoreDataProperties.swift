//
//  Room+CoreDataProperties.swift
//  ARProject
//
//  Created by Anubhav Rawat on 03/10/22.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var model: Set<ModelObject>?
    public var models: [ModelObject]{
        let set = model
        return set!.sorted{
            $0.name! < $1.name!
        }
    }
}

// MARK: Generated accessors for model
extension Room {

    @objc(addModelObject:)
    @NSManaged public func addToModel(_ value: ModelObject)

    @objc(removeModelObject:)
    @NSManaged public func removeFromModel(_ value: ModelObject)

    @objc(addModel:)
    @NSManaged public func addToModel(_ values: NSSet)

    @objc(removeModel:)
    @NSManaged public func removeFromModel(_ values: NSSet)

}

extension Room : Identifiable {

}
