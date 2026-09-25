//
//  Item.swift
//  ScreensaverPreviewApp
//
//  Created by Jenny Brown on 9/25/26.
//  Copyright © 2026 Jenny Brown. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
