//
//  ArticleCoreData+CoreDataProperties.swift
//  ViesureiOSTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//
//

import Foundation
import CoreData

extension ArticleCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleCoreData> {
        return NSFetchRequest<ArticleCoreData>(entityName: "ArticleCoreData")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var id: Int32
    @NSManaged public var image: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var title: String?

}

extension ArticleCoreData: Identifiable {

}
