//
//  Event+CoreDataProperties.swift
//  FGOsimulator
//
//  Created by Yasuteru on 2018/07/27.
//  Copyright © 2018年 Yasuteru. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var imgarr: NSData?
    @NSManaged public var image: NSSet?

}

// MARK: Generated accessors for image
extension Event {

    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: Image)

    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: Image)

    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)

    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)

}
