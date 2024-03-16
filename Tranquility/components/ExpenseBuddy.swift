import SwiftUI

struct ExpenseBuddy: View {
    let buddy: Buddy
    let balance: Balance
    
    init(buddy: Buddy) {
        self.buddy = buddy
        self.balance = Balance(balance: self.buddy.balance)
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(balance.status)
                    .font(.body)
                    .foregroundStyle(Color.secondary)
                Group {
                    if buddy.balance != 0 {
                        Text(balance.asFormatted)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(balance.color)
                            .lineLimit(1)
                    } else {
                        Image(systemName: "checkmark.circle").foregroundStyle(balance.color).font(.title).fontWeight(.bold)
                    }
                }.padding(.top, 1)
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .center)
            Spacer()
            HStack  {
                ParticipantAvatar(participant: buddy.participant)
                Text(buddy.name)
                    .font(.caption)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .lineLimit(1)
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        }
        .frame(maxWidth: .infinity, minHeight: 176, maxHeight: .infinity)
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(13)
        
    }
}


struct ExpenseBuddy_Previews: PreviewProvider {
    static var buddy = Buddy.sampleData[0]
    static var previews: some View {
        ExpenseBuddy(buddy: buddy).frame(maxWidth: 200, maxHeight: 200)
    }
}

