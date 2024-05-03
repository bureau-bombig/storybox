//
//  NSSecureUnarchiveFromDataTransformer.swift
//  Storybox
//
//  Created by User on 02.05.24.
//

import Foundation
import CoreData

@objc(QuestionIDsValueTransformer)
class QuestionIDsValueTransformer: NSSecureUnarchiveFromDataTransformer {
    // Define the types that this transformer will allow. We are working with an array of integers.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSNumber.self]
    }

    static func register() {
        let transformer = QuestionIDsValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("QuestionIDsValueTransformer"))
    }
}
