//
//  AdviceView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 5/2/23.
//

import SwiftUI

struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}


//
//  ContentView.swift
//  MobGPT
//
//  Created by Furkan Hanci on 12/23/22.
//


struct AdviceView: View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    @ObservedObject var apiRequestManager = ChatRequestManager()
    @State private var inputText: String = ""

    var body: some View {
        VStack(spacing: 25) {
            
            Text("\(viewModel.getRecipesForAdvice())")

            TextField("Ask...", text: $inputText)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.orange, style: StrokeStyle(lineWidth: 1.5)))
                .padding()

            Button(action: {
                self.apiRequestManager.makeRequest(text: inputText)
             }) {
                 Text("Ask MobGPT")
                     .frame(minWidth: 0, maxWidth: .infinity)
                     .font(.system(size: 18))
                     .fontWeight(.bold)
                     .padding()
                     .foregroundColor(.white)
                     .overlay(
                         RoundedRectangle(cornerRadius: 20)
                             .stroke(Color.white, lineWidth: 1)
                 )
             }
             .background(Color.green)
             .cornerRadius(20)

            if let data = apiRequestManager.responseData {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let choices = json["choices"] as? [[String: Any]] {
                        if let text = choices[0]["text"] as? String {
                            Text(text)
                        }
                    }
                }
            }
        }
    }
}
