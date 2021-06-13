//
//  DPSortDescription+Extention.swift
//  PDC
//
//  Created by jitendra on 05/06/18.
//  Copyright © 2018 jitendra. All rights reserved.
//

import Foundation

extension NSSortDescriptor {
    
    public static func descriptor(_ key:String?,_ ascending:Bool = true) -> NSSortDescriptor{
        return NSSortDescriptor.init(key: key, ascending: ascending)
    }
}
