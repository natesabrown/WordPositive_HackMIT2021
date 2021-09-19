//
//  WordPreview.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct WordPreview: View {
  var word: Word
  @State private var expanded = false
  @AppStorage("words") var words: [Word] = []
  
  var body: some View {
    let level = word.level
    let levelColor = Word.getColorFromLevel(level: level)
    
    VStack(alignment: .leading) {
      HStack {
        Text(word.name)
          .font(.title2)
          .bold()
        Spacer()
        Button(action: {
          Word.speakWord(word: word)
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
                  .lineLimit(nil)
                  .frame(maxHeight: .infinity)
                  
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
              words = words.filter { $0 != word }
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
    .background(Color.white.cornerRadius(25).opacity(0.8).shadow(radius: 2))
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
    WordPreview(word: .ExampleWords[3])
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
