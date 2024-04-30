//
//  NoAccessoryTextField.swift
//  Storybox
//
//  Created by User on 28.04.24.
//

import UIKit

class NoAccessoryTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autocorrectionType = .no  // Disable predictive text
        self.autocapitalizationType = .none  // Optionally disable auto-capitalization
        self.smartDashesType = .no  // Disable smart dashes
        self.smartQuotesType = .no  // Disable smart quotes
        self.smartInsertDeleteType = .no  // Disable smart insert/delete
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
