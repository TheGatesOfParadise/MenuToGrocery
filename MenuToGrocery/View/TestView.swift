//
//  TestView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 5/7/23.
//

import SwiftUI

struct TestView: View {
    var fruits = ["Banana","Apple", "Peach", "Watermelon", "Grapes" ]
    @State private var selectedFruit = 0

    var body: some View {
        Form {
            // Variation 1
            Picker(selection: $selectedFruit, label: Text("Select Favorite Fruit")) {
                ForEach(0..<fruits.count, id: \.self) {
                    Text(self.fruits[$0])
                }
            }
            // Variation 2
            Picker(selection: $selectedFruit) {
                ForEach(0..<fruits.count, id: \.self) {
                    Text(self.fruits[$0])
                }
            } label: {
                HStack {
                    Text("Favorite Fruit")
                    Divider()
                    Text(fruits[selectedFruit])
                }
            }
            // Variation 3
            Menu {
                ForEach(0..<fruits.count, id: \.self) {
                    Text(self.fruits[$0])
                }
            } label: {
                HStack {
                    Text("Favorite Fruit")
                    Divider()
                    Text(fruits[selectedFruit])
                }
            }
        }
        .pickerStyle(.menu)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
