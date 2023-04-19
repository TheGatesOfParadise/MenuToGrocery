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
            
           MealPlanView()
                .tabItem {
                    Label("Mean Plan", systemImage: "book")
                    
                }
           /*     .tabItem {
                     ScaledImage(name: "local_dining", size: CGSize(width: 26, height: 26))
                        .foregroundColor(.pink)
                     Text("Meal Plan")
                 }
            
            */
            
            FavoriteView()
                 .tabItem {
                     Label("Favorite", systemImage: "heart")
                 }
            GroceryView()
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


struct ScaledImage: View {
    let name: String
    let size: CGSize
    
    var body: Image {
        let uiImage = resizedImage(named: self.name, for: self.size) ?? UIImage()
        
        return Image(uiImage: uiImage.withRenderingMode(.alwaysOriginal))
    }
    
    func resizedImage(named: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
