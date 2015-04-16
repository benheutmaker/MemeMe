//
//  Meme.swift
//  MemeMe
//
//  Created by Benji on 4/8/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class Meme {
    var topText : String
    var bottomText : String
    var image : UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
