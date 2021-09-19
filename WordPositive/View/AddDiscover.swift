//
//  AddDiscover.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct AddDiscover: View {
  var name: String
  var color: Color
  @State var definition: String?
  @State var word: Word? = nil
  @AppStorage("words") var words: [Word] = []
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(name)
        .font(.largeTitle)
        .bold()
        .padding(.top)
      Divider()
      if definition != nil {
        Text(definition!)
      }
      Spacer()
      HStack {
        Spacer()
        Button(action: {
          guard let word = word else { return }
          words.append(word)
          presentationMode.wrappedValue.dismiss()
        }) {
          Text("Add")
            .bold()
            .font(.title)
            .padding()
            .padding(.horizontal)
            .background(
              RoundedRectangle(cornerRadius: 22).strokeBorder(style: StrokeStyle(lineWidth: 4)))
        }
        Spacer()
      }
      .padding(.bottom)
    }
    .foregroundColor(.white)
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(color.edgesIgnoringSafeArea(.all))
    .onAppear {
      Word.getWords(text: name, onComplete: { words in
        guard let word = words?[0] else { return }
        print(word)
        self.word = word
        definition = word.definition
      })
    }
  }
  
}

//struct AddDiscover_Previews: PreviewProvider {
//  static var previews: some View {
//    AddDiscover(name: "Obsequious", color: .green)
//  }
//}
