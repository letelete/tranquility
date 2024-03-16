//
//  Buddy.swift
//  Tranquility
//
//  Created by Bruno Kawka on 16/03/2024.
//

import Foundation
import SwiftUI

struct Buddy {
    var name: String
    
    var participant: Participant
    
    var balance: Int
}



extension Buddy {
    static let sampleData: [Buddy] = [
        Buddy(name: "Kate Upton",
              participant: Participant.sampleData[0],
              balance: -1223),
        
        Buddy(name: "John Doe",
              participant: Participant.sampleData[1],
              balance: 132),
        
        Buddy(name: "Bob Unknown",
              participant: Participant.sampleData[2],
              balance: 0),
    ]
}
