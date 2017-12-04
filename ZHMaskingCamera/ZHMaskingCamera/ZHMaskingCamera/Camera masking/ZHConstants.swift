//
//  ZHConstants.swift
//  Zeeshan Haider
//
//  Created by Zeeshan Haider on 02/12/2017.
//  Copyright © 2017 ZHMaskingCamera. All rights reserved.
//

import Foundation
import UIKit

class ZHConstants : NSObject {
    static let cameraRatio : Float =  ZHConstants.kIS_IPAD ? 2.4 : 1.2 
    
    static let kIS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let kIS_IPHONE = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
}
