//
//  PhoeneticView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import SwiftUI
import AVFoundation

struct PhoneticView: View {
    var phonetic: Phonetics?
    var typeOfWord:String
    var sourceUrl:String?
    var text:String
    @Environment(\.colorScheme) var colorScheme
    @State private var audioPlayer: AVPlayer?
    @State private var isPlaying = false
    @State private var observer: NSObjectProtocol?
    init( phonetics: [Phonetics], typeOfWord:String) {
        let phonetic = phonetics.compactMap { $0 }.first
        self.phonetic =  phonetic
        self.text = phonetic?.text ?? ""
        self.sourceUrl = phonetic?.audio ?? ""
        self.typeOfWord = typeOfWord
    }
    
    var body: some View {
        if (!text.isEmpty) {
            VStack(alignment: .leading,spacing: 5) {
                Text("Phonetics")
                    .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 16, weight: .medium)
                
                HStack {
                    Text(text)
                        .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 18, weight: .medium)
                    Spacer()
                    if let sourceUrl = sourceUrl, !sourceUrl.isEmpty {
                        Button(action: {
                            playAudio()
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .contentTransition(.symbolEffect(.replace))
                                .animation(.spring(response: 0.45, dampingFraction: 0.75), value: isPlaying)
                                .foregroundColor(AppColors.textInverted(colorScheme: colorScheme))
                                .font(.system(size: 30))
                        }
                        .hapticFeedback(style: .light)
                        .buttonStyle(BouncyButton())
                    }
                }
                .padding(.horizontal, 20)
            }
            .onDisappear {
                audioPlayer?.pause()
                audioPlayer = nil
                if let observer = observer {
                    NotificationCenter.default.removeObserver(observer)
                }
            }
        }
    }
    
    private func playAudio() {
        debugLog("sourceUrl: \(sourceUrl)")
        guard let sourceUrl = sourceUrl, let url = URL(string: sourceUrl) else { return }
        
        debugLog("Trying to play:", url.absoluteString)
        
        if isPlaying {
            
            audioPlayer?.pause()
            isPlaying = false
        } else {
            // Play audio
            if audioPlayer == nil {
                audioPlayer = AVPlayer(url: url)
                
                
                if let playerItem = audioPlayer?.currentItem {
                    observer = NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: playerItem,
                        queue: .main
                    ) { _ in
                        isPlaying = false
                    }
                }
            }
            audioPlayer?.seek(to: .zero)
            audioPlayer?.play()
            isPlaying = true
        }
    }
}

#Preview {
    PhoneticView(phonetics: [], typeOfWord: "")
}
