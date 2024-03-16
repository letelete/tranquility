//
//  ContentView.swift
//  Tranquility
//
//  Created by Bruno Kawka on 16/03/2024.
//

import SwiftUI

struct ContentView: View {
    var userBalance: Int
    var balance: Balance
    var buddies: [Buddy]
    var hasBuddies: Bool
    
    init() {
        self.userBalance = -11
        self.balance = Balance(balance: self.userBalance)
        self.buddies = Buddy.sampleData
        self.hasBuddies = self.buddies.count > 0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Tranquility")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "ellipsis.circle")
                }
            }
            Group {
                if hasBuddies {
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Total balance: ")
                                Text(balance.asFormatted).foregroundColor(balance.color)
                            }.font(.body).padding(.leading, 8).padding(.top, 48)
                            Text("Expense buddies")
                                .font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding(.leading, 8)
                                .padding(.top, 48)
                            ExpenseBuddiesGrid(buddies: buddies)
                        }
                    }
                }
                else {
                    Text("Bring tranquility to your finances by adding your first expense buddy!").foregroundStyle(.secondary).padding().multilineTextAlignment(.center)
                        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                }
            }
            Spacer()
            HStack {
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                    Text("New expense")
                }.disabled(!hasBuddies)
                Spacer()
                Button(action: {}) {
                    Text("Add expense buddy")
                }
            }
        }.padding()
    }
}

#Preview {
    ContentView()
    
}
