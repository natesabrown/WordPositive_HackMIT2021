//
//  Catalogue.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct Catalogue: View {
  @AppStorage("words") var words: [Word] = []
  
  var body: some View {
    let sortedWords = words.sorted(by: { $0.name < $1.name })
    
    NavigationView {
      ZStack {
        ScrollView {
          Spacer().frame(height: 25)
          ForEach(sortedWords, id: \.self) { word in
            WordPreview(word: word)
              .padding(.horizontal)
              .padding(.vertical, 3)
          }
        }
      }
      .navigationBarTitle(Text("My Catalogue"))
      .toolbar {
        NavigationLink(destination: AddWord(onComplete: { result in
          words.append(result)
        })) {
          Image(systemName: "plus.circle.fill")
        }
      }
    }
  }
}

struct Catalogue_Previews: PreviewProvider {
  static var previews: some View {
    Catalogue()
  }
}
