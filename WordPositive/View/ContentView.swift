//
//  ContentView.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      Catalogue()
        .tabItem {
          Image(systemName: "rectangle.stack")
          Text("Catalogue")
        }
      Practice()
        .tabItem {
          Image(systemName: "questionmark")
          Text("Practice")
        }
      Discover()
        .tabItem {
          Image(systemName: "globe")
          Text("Discover")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
