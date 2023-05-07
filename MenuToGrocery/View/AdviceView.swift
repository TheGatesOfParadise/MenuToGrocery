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
    @ObservedObject var mealViewModel = MealPlanViewModel.shared
    @ObservedObject var chatGPTViewModel = ChatGPTViewModel.shared
    @State private var age:Int = 18
    @State private var sexSelection = "Female"
    let sexList = ["Male", "Female"]
    @State private var number: Int = 1

    var body: some View {
        VStack(spacing: 25) {
            
            Form{
                Picker(selection: $sexSelection, label: Text("Sex")) {
                    ForEach(sexList, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                Picker(selection: $age, label: Text("Your age")) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
            .frame(height: 150)
            
            Text("Your meal plan includes \(mealViewModel.getRecipesForAdvice())")
                .frame(height: 50)
            
      /*    Spacer()
            TextField("Ask...", text: $inputText)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.orange, style: StrokeStyle(lineWidth: 1.5)))
                .padding()
           */


            Button(action: {
                self.chatGPTViewModel.getMealPlanAdvice(mealPlan: mealViewModel.getRecipesForAdvice(),
                                                   age:age,
                                                   sex:sexSelection)
             }) {
                 Text("Consult chatGPT on your meal plan")
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
             .disabled(!mealViewModel.readyForAdvice())
            
            //chatGPT answer
            Text("\(chatGPTViewModel.advice)")
                //.frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 400)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .padding()
                //.foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
            )
            
        Spacer()
        }
        .frame(width:UIScreen.screenWidth - 20)
    }
}
