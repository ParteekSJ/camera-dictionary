//
//  RoundedShadowImageView.swift
//  CameraDictionary
//
//  Created by Parteek Singh on 4/5/20.
//  Copyright © 2020 ParteekSJ. All rights reserved.
//

import UIKit

class RoundedShadowImageView: UIImageView {
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = 15
    }

}
