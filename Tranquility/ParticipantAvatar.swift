//
//  ParticipantsAvatars.swift
//  Tranquility
//
//  Created by Bruno Kawka on 16/03/2024.
//

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
                            ProgressView().frame(idealWidth: 16)
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 16)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }}
                } else {
                    Image(systemName: "photo").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 16)
                }
            }.clipShape(Circle())
        }
    }
}

#Preview {
    ParticipantAvatar(participant: Participant.sampleData[0])
}
