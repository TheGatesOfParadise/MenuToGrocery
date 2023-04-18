//
//  ContentView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/17/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "search")
                }
            
           Text("search")
                .tabItem {
                    Label("Mean Plan", systemImage: "tuningfork")
                }
            Text("grocery list")
                 .tabItem {
                     Label("Grocery List", systemImage: "list.dash")
                 }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
