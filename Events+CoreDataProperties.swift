//
//  Events+CoreDataProperties.swift
//  FGOsimulator
//
//  Created by Yasuteru on 2018/07/26.
//  Copyright © 2018年 Yasuteru. All rights reserved.
//
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imgarr: NSData?

}
