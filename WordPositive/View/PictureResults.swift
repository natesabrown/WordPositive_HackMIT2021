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
  
  var body: some View {
    VStack {
      Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 200)
        .cornerRadius(20)
        .shadow(radius: 3)
        .padding(.bottom)
      if !doneAnalyzing {
        ProgressView("Analyzing Image...")
      }
    }
    .navigationBarTitle("Text from Image")
    .onAppear {
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
  func recognizeTextHandler(request: VNRequest, error: Error?) {
    guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
    let recognizedStrings = observations.compactMap { observation in
      return observation.topCandidates(1).first?.string
    }
    
    withAnimation {
      doneAnalyzing = true
    }
    words = recognizedStrings
  }
}

struct PictureResults_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      PictureResults(image: UIImage(named: "example_text")!)
    }
  }
}
