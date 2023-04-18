//
//  TestView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/17/23.
//

import SwiftUI

struct TestView: View {
    @State var selectedOption = 0
    //@State private var selectedOption = 0
    let options = ["empty", "American", "Asian", "British"]
    
    var body: some View {
        HStack {
            //Text("Cuisine stype: \(options[selectedOption])")
            Text("Cuisine stype:")
            Picker(selection: $selectedOption, label: Text(options[selectedOption])) {
                ForEach(0..<options.count) { index in
                    Text(options[index]).tag(index)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 200)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


struct HorizontalRadioButtonGroup: View {
    @Binding var selectedOption: Int
    let options: [String]
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<options.count) { index in
                Button(action: {
                    selectedOption = index
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: selectedOption == index ? "largecircle.fill.circle" : "circle")
                        Text(options[index])
                    }
                }
            }
        }
    }
}
