//
//  PictureResults.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI
import Vision

struct PictureResults: View {
  var image: UIImage
  @State var words: [String]? = nil
  @State var doneAnalyzing = false
  @Environment(\.presentationMode) var presentationMode
  var onWordPress: ((String) -> Void)? = nil
  
  var body: some View {
    VStack {
      Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 200)
        .cornerRadius(20)
        .shadow(radius: 3)
        .padding(.vertical)
      if !doneAnalyzing {
        ProgressView("Analyzing Image...")
      }
      if words != nil && words!.count > 0 {
        VStack {
          Text("Found Words:")
            .font(.title2)
            .bold()
          WordsView(words: words!, onWordPress: onWordPress)
        }
      }
    }
    .animation(.default)
    .navigationBarTitle("Text from Image")
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLevel = .accurate

        do {
          try requestHandler.perform([request])
        } catch {
          print("Unable to perform the requests: \(error)")
        }
      }
    }
  }
  func recognizeTextHandler(request: VNRequest, error: Error?) {
    guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
    let recognizedStrings = observations.compactMap { observation in
      return observation.topCandidates(1).first?.string
    }
    
    let tentativeWords = recognizedStrings
    print(tentativeWords)
    var actualWords: [String] = []
    for string in tentativeWords {
      for word in string.components(separatedBy: " ") {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
          if word.count > 2 {
            actualWords.append(word.lowercased())
          }
        }
      }
    }
    print(actualWords)
    
    withAnimation {
      doneAnalyzing = true
      words = Array(Set(actualWords))
    }
  }
}

struct PictureResults_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      PictureResults(image: UIImage(named: "example_text")!)
    }
  }
}
