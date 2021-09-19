//
//  WordsView.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct WordsView: View {
  var words: [String]
  var onWordPress: ((String) -> Void)?
  
  let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(words, id: \.self) { word in
          Button(action: {
            if onWordPress != nil {
              onWordPress!(word)
              presentationMode.wrappedValue.dismiss()
            }
          }) {
            Text(word)
              .bold()
              .frame(maxWidth: .infinity)
              .foregroundColor(.white)
              .padding(5)
              .background(Color.blue.cornerRadius(5))
              .minimumScaleFactor(0.5)
          }
        }
      }
    }
    .padding()
    .background(Color.white.cornerRadius(20).shadow(radius: 3))
    .padding()
    .padding(.horizontal)
  }
}

struct WordsView_Previews: PreviewProvider {
  static var previews: some View {
    WordsView(words: ["potato", "salad", "very", "good", "say", "myself", "indeed"])
  }
}
