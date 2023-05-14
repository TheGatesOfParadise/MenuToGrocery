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


struct AdviceView: View {
    @ObservedObject var mealViewModel = MealPlanViewModel.shared
    @ObservedObject var chatGPTViewModel = ChatGPTViewModel.shared
    @State private var age:Int = 17
    @State private var sexSelection = "Female"
    let sexList = ["Male", "Female"]
    @State private var number: Int = 1
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 30, height: 3)
            
            Form{
                Picker(selection: $sexSelection, label: Text("Sex")) {
                    ForEach(sexList, id: \.self) {
                        Text($0)

                    }
                    .pickerStyle(.menu)
                }
                ScrollView{
                    Picker(selection: $age, label: Text("Your age")) {
                        ForEach(1...100, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.menu)
                    
                }
            }
                Button(action: {
                    self.chatGPTViewModel.getMealPlanAdvice(mealPlan: mealViewModel.getRecipesForAdvice(),
                                                            age:age,
                                                            sex:sexSelection)
                }) {
                    //Text("Consult chatGPT on your meal plan")
                    Text(chatGPTViewModel.hasAdvice() ? "Answer" : "Consult ChatGPT on your meal plan")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.red, lineWidth: 1)
//                        )
                }
                .background(chatGPTViewModel.hasAdvice() ? .green: .blue)
                .cornerRadius(20)
                .position(x: 195, y:-40)
                .disabled(!mealViewModel.readyForAdvice() || chatGPTViewModel.hasAdvice())
                
                //chatGPT answer
                VStack{
                    Text("\(chatGPTViewModel.advice)")
                        .frame(width: UIScreen.screenWidth - 80)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .position(x: 195, y:-50)
                    Spacer()
                }
            
            Spacer()
            Spacer()
            
        }
        .frame(width:UIScreen.screenWidth - 20)
        .onAppear{
            chatGPTViewModel.emptyAdvice()

        }
    }
}
