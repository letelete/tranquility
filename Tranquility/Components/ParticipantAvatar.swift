import SwiftUI

struct ParticipantAvatar: View {
    let participant: Participant
    
    var body: some View {
        VStack {
            Group {
                if (participant.pictureUrl != nil) {
                    AsyncImage(url: URL(string: participant.pictureUrl!)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(width: 24)
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }}
                } else {
                    HStack {
                        let name = String(participant.name[participant.name.startIndex]) + String(participant.name.split(separator: " ")[1][participant.name.split(separator: " ")[1].startIndex])
                        
                        ZStack {
                            Circle().frame(width: 24, height:24)
                                .foregroundStyle(Color(.systemGray5))
                            Text(name).font(.caption2).fontWeight(.bold)
                        }
                    }
                }
            }.clipShape(Circle())
        }
    }
}

#Preview {
    ParticipantAvatar(participant: Participant.sampleData[1])
}
