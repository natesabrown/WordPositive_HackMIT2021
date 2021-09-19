//
//  PracticeGame.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct PracticeGame: View {
  var items: [Word]
  @AppStorage("words") var words: [Word] = []
  @State private var index = 0
  @State private var flipped = false
  var everyWord = false
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    let currentWord = items[index]
    
    VStack {
      HStack {
        Spacer()
        Text("\(index + 1)/\(items.count)")
          .font(.title)
          .bold()
      }
      Spacer()
      Button(action: {
        self.flipped.toggle()
      }) {
        VStack {
          Group {
            if !flipped {
              Text(currentWord.name)
            } else {
              Text(currentWord.definition)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
          }
        }
        .foregroundColor(.black)
        .frame(maxWidth: 250, maxHeight: 250)
        .padding()
        .background(Color.white.cornerRadius(20).shadow(radius: 3))
        .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
        .animation(.default)
      }
      Spacer()
      Spacer()
      HStack {
        ForEach(1...5, id: \.self) { num in
          HStack {
            Spacer()
            Button(action: {
              if everyWord {
                if index == (items.count - 1) {
                  presentationMode.wrappedValue.dismiss()
                } else {
                  flipped = false
                  index += 1
                }
                return
              }
              // add x days to when you need to study the word next
              // and change confidence level
              for (index, word) in words.enumerated() {
                if word == currentWord {
                  // next date
                  var newWord = word
                  let currentDate = Date()
                  var dateComponent = DateComponents()
                  dateComponent.day = num
                  let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                  newWord.nextTime = futureDate
                  
                  // confidence level
                  if newWord.level == 0 {
                    newWord.level = 1
                  }
                  else if num == 4 || num == 5 {
                    if newWord.level != 5 {
                      newWord.level += 1
                    }
                  } else {
                    if newWord.level != 1 {
                      newWord.level -= 1
                    }
                  }
                  
                  words[index] = newWord
                }
              }
              
              if index != (items.count - 1) {
                index += 1
              } else {
                presentationMode.wrappedValue.dismiss()
              }
              flipped = false
            }) {
              Text("\(num)")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .background(Word.getColorFromLevel(level: num).frame(width: 50, height: 50).cornerRadius(50))
            }
            Spacer()
          }
        }
      }
      .padding(.horizontal)
    }
    .padding()
    .navigationBarTitle("Game")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct PracticeGame_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      PracticeGame(items: Word.ExampleWords)
    }
  }
}
