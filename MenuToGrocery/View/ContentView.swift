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
                    Label("Search", systemImage: "magnifyingglass")
                }
            
           Text("Mean Plan")
                .tabItem {
                  //  Label("Mean Plan",
                   //       image: "local_dining")
                    
                    Label { Text("Mean Plan") .font(.largeTitle.lowercaseSmallCaps()) } icon: { Image("local_dining") .resizable() .frame(width: 30, height: 30) .clipShape(Circle()) }
                    
                }
            
            Text("Favorite")
                 .tabItem {
                     Label("Favorite", systemImage: "heart")
                 }
            Text("Grocery list")
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
