//
//  WordPreview.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI
import AVFoundation

struct WordPreview: View {
  var word: Word
  @State private var expanded = false
  
  var body: some View {
    var level = word.level
    var levelColor = getColorFromLevel(level: level)
    
    
    VStack(alignment: .leading) {
      HStack {
        Text(word.name)
          .font(.title2)
          .bold()
        Spacer()
        Button(action: {
          // read word title aloud
          let utterance = AVSpeechUtterance(string: word.name)
          utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
          let synthesizer = AVSpeechSynthesizer()
          synthesizer.speak(utterance)
        }) {
          Image(systemName: "speaker.wave.2.circle.fill")
            .font(.title2)
        }
      }
      Divider()
      HStack {
        HStack {
          Text(word.definition)
            .font(.caption)
            .foregroundColor(.gray)
          Spacer()
        }
        Button(action: {
          withAnimation {
            expanded.toggle()
          }
        }) {
          Image(systemName: expanded ? "chevron.up" : "chevron.down")
        }
      }
      if expanded {
        VStack(alignment: .leading) {
          Text(word.partOfSpeech)
            .padding(.bottom, 1)
          if word.examples != nil {
            ForEach(word.examples!, id: \.self) { example in
              HStack {
                Text("\u{2022} \(example)")
                  .font(.caption)
                  .bold()
                Spacer()
              }
            }
          }
          HStack(alignment: .bottom) {
            HStack {
              ForEach(0..<level) { _ in
                LevelRectangle()
                  .foregroundColor(levelColor)
              }
              ForEach(level..<5) { _ in
                LevelRectangle()
                  .foregroundColor(Color(.systemGray5))
              }
            }
            .padding(.top, 4)
            Spacer()
            Button(action: {
              
            }) {
              Image(systemName: "trash.circle.fill")
                .foregroundColor(.red)
                .font(.title2)
            }
          }
        }
        .padding(.top, 2)
      }
    }
    .padding()
    .background(Color.white.cornerRadius(25).shadow(radius: 2))
  }
  
  func getColorFromLevel(level: Int) -> Color {
    switch(level) {
    case 1: return .red
    case 2: return .orange
    case 3: return .yellow
    case 4: return Color.green.opacity(0.5)
    case 5: return .green
    default: return .black
    }
  }
}

struct LevelRectangle: View {
  var body: some View {
    Rectangle()
      .frame(width: 40, height: 5)
      .cornerRadius(3)
  }
}

struct WordPreview_Previews: PreviewProvider {
  static var previews: some View {
    WordPreview(word: .ExampleWords[0])
  }
}
