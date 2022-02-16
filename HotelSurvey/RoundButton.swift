//
//  RoundButton.swift
//  HotelSurvey
//
//  Created by Lokesh on 10/10/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.height/2
    }
}
