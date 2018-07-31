//
//  Image+CoreDataProperties.swift
//  FGOsimulator
//
//  Created by Yasuteru on 2018/07/27.
//  Copyright © 2018年 Yasuteru. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var imgname: String?
    @NSManaged public var event: Event?

}
