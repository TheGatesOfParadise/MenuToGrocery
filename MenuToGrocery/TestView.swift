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
    @State var sheetIsUp = false
    @State var recipe = Recipe.sample(index: 0)
    
    var body: some View {
        VStack {
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
            Button("abc", action: {
                sheetIsUp.toggle()
            })
            
            
            VStack (alignment: .leading) {
                Text("Ingredients:")
                    .font(.system(size: 20 ,weight: .medium))
                    .padding(.bottom, 12)
                
                ForEach(recipe.ingredients) { ingredient in
                    HStack{
                        Text(ingredient.text)
                            .foregroundColor(.blue)
                            .fixedSize(horizontal: false, vertical: true)
                            
                        //Text("\(String(format: "%.2f", ingredient.quantity))")
                            .foregroundColor(.green)
                        //Text(ingredient.measure ?? "")
                            .foregroundColor(.black)
                        //Text(ingredient.food)
                            .foregroundColor(.blue)
                        //Text("\(String(format: "%.2f", ingredient.weight))")
                        //    .foregroundColor(.yellow)
                    }
                }
            }
            .padding([.leading,.trailing],15 )
            
            List {
                // 1
                Section("Ingredients") {
                    ForEach(recipe.ingredients) { ingredient in
                        HStack{
                            Text(ingredient.text.capitalized)
                                .foregroundColor(.blue)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                // 3
                Section(content: {
                    Text("App Store")
                    Text("Wallet")
                }, footer: {
                    Text("Molestiae commodi sunt eaque libero aspernatur totam voluptatum fugit.")
                })
            }
            
        }
        .sheet(isPresented: $sheetIsUp){
            Text("\(String(format: "%.2f", 10.2343))")
                .presentationDetents([.medium, .large])
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
