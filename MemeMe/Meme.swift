//
//  Meme.swift
//  MemeMe
//
//  Created by Doug Mason on 12/13/15.
//  Copyright © 2015 Doug Mason. All rights reserved.
//

import UIKit

struct Meme {
    var topText : String!
    var bottomText : String!
    var image: UIImage!
    var memedImage : UIImage!
    init(topText: String!, bottomText: String! , image: UIImage!, memedImage: UIImage!){
        self.topText =  topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}