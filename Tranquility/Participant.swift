//
//  Participant.swift
//  Tranquility
//
//  Created by Bruno Kawka on 16/03/2024.
//

import Foundation
import SwiftUI

struct Participant {
    var name: String
    
    var email: String
    
    var pictureUrl: String?
}



extension Participant {
    static let sampleData: [Participant] = [
        Participant(name: "Kate Upton",
                    email: "kate.upton@gmail.com",
                    pictureUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
        Participant(name: "John Doe",
                    email: "john.doe@gmail.com"),
        Participant(name: "Bob Uknown",
                    email: "bob.unknown@gmail.com"),
    ]
}
