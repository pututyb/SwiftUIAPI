//
//  ContentView.swift
//  SwiftUIAPI
//
//  Created by Putut Yusri Bahtiar on 08/02/23.
//

import SwiftUI
import AVFoundation


struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var artistName: String
    var trackId: Int
    var trackName: String
    var collectionName: String
    var artworkUrl30: String
    var previewUrl: String
}

struct ContentView: View {
    @State private var results = [Result]()
    @State private var player: AVPlayer?
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                HStack {
                    AsyncImage(url: URL(string: item.artworkUrl30))
                        .padding()
                    Text(item.artistName)
                        .font(.headline)
                        .bold()
                }
                
                Button(action: {
                    if let url = URL(string: item.previewUrl) {
                        self.play(url: url)
                    }
                }) {
                    Text("Play Preview")
                }

                
                
                Text(item.trackName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else { print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
