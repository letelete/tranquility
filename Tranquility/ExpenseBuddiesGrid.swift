//
//  ExpenseBuddiesGrid.swift
//  Tranquility
//
//  Created by Bruno Kawka on 16/03/2024.
//

import SwiftUI

struct ExpenseBuddiesGrid: View {
    let buddies: [Buddy]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(buddies, id: \.name) { buddy in
                ExpenseBuddy(buddy: buddy)
            }
        }
    }
}

struct ExpenseBuddiesGrid_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseBuddiesGrid(buddies: Buddy.sampleData)
    }
}
