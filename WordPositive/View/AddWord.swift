//
//  AddWord.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct AddWord: View {
  @State private var results: [Word]? = nil
  @State private var text: String = ""
  @State private var isAdding = false
  @State private var image = UIImage()
  @State private var showSheet = false
  @State private var moveNavigation = false
  var onComplete: ((Word) -> Void)?
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @AppStorage("words") var words: [Word] = []
  
  @State private var sentences: [String]? = nil
  
  var body: some View {
    ZStack {
      VStack {
        HStack {
          TextField("Enter Word", text: $text)
            .padding()
            .background(Color(.systemGray5).cornerRadius(15).shadow(radius: 1))
          Button(action: {
            hideKeyboard()
            Word.getWords(text: text.trimmingTrailingSpaces()) { words in
              withAnimation {
                results = words
              }
            }
          }) {
            Image(systemName: "magnifyingglass.circle.fill")
              .resizable()
              .frame(width: 35, height: 35)
              .offset(x: 5)
          }
          .padding(.trailing)
        }
        .padding(.horizontal)
        .padding(.top)
        
        if results != nil {
          VStack(alignment: .leading) {
            Text("Results")
              .font(.title2)
              .bold()
              .padding(.horizontal)
            Divider()
            ScrollView {
              ForEach(results!, id: \.self) { result in
                Button(action: {
                  // add to collection
                  withAnimation {
                    isAdding = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                      isAdding = false
                      presentationMode.wrappedValue.dismiss()
                      if onComplete != nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                          onComplete!(result)
                        }
                      }
                    }
                  }
                }) {
                  ChoosePreview(word: result)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                }
              }
            }
          }
          .padding(.top)
          Divider()
            .offset(y: -8)
        }
        
        Spacer()
        
        Button(action: {
          showSheet = true
        }) {
          VStack {
            Image(systemName: "camera.fill")
            Text("Use Camera")
          }
          .font(.title)
          .padding()
          .padding(.horizontal)
          .background(RoundedRectangle(cornerRadius: 10).strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [10])))
          .padding(.vertical)
        }
      }
      if isAdding {
        VStack {
          Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 70, height: 70)
          Text("Added!")
        }
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding()
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .background(Color.green.cornerRadius(20).opacity(0.95))
        .offset(y: -40)
      }
      
      
      NavigationLink(destination: PictureResults(image: image, sentences: $sentences, onWordPress: { wordString in
        text = wordString
        // get the results
        Word.getWords(text: text.trimmingTrailingSpaces()) { words in
          withAnimation {
            results = words
          }
        }
        // add a custom result if our API works
        var ourSentence = ""
        if (sentences != nil) {
          for sentence in sentences! {
            if sentence.contains(text) {
              print("Got it!")
              ourSentence = sentence
            }
          }
          
          print("Got word \(text), sentence \(ourSentence)")
          Word.getDefFromContext(word: text, sentence: ourSentence) { result in
            if result != nil {
              let newWord = Word(
                name: text,
                partOfSpeech: "noun",
                definition: result!,
                level: 0)
              if results != nil {
                results!.append(newWord)
                print("Done appending.")
              }
            }
          }
        }
        
      }), isActive: $moveNavigation) {
        EmptyView()
      }
    }
    .sheet(isPresented: $showSheet) {
      ImagePicker(selectedImage: $image)
        .edgesIgnoringSafeArea(.all)
    }
    .navigationBarTitle("Add Word")
    .onChange(of: image) { _ in
      self.moveNavigation = true
    }
      
  }
}

struct ChoosePreview: View {
  var word: Word
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(word.name)
          .bold()
        Spacer()
        Button(action: {
          Word.speakWord(word: word)
        }) {
          Image(systemName: "speaker.wave.2.circle.fill")
            .foregroundColor(.blue)
        }
      }
      .font(.title2)
      Divider()
      Text(word.partOfSpeech)
      Text(word.definition)
        .font(.footnote)
        .foregroundColor(.gray)
      if word.examples != nil {
        ForEach(word.examples!, id: \.self) { example in
          Text("\u{2022} \(example)")
            .italic()
            .padding(.vertical, 3)
        }
      }
      if word.synonyms != nil {
        HStack {
          // semi-hack to ensure synonyms don't spill over
          ForEach(word.synonyms!.prefix(2), id: \.self) { synonym in
            Text(synonym)
              .foregroundColor(.white)
              .padding(3)
              .background(Color.gray.cornerRadius(10))
          }
        }
      }
    }
    .foregroundColor(.black)
    .padding()
    .background(Color.white.cornerRadius(10).shadow(radius: 3))
  }
}

struct AddWord_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        AddWord()
      }
      Button(action: { }) {
        ChoosePreview(word: .ExampleWords[0])
          .padding()
      }
      .previewLayout(.sizeThatFits)
    }
  }
}
