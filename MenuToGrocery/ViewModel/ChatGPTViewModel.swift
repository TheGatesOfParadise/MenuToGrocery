//
//  ChatGPTViewModel.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 5/7/23.
//

import Foundation
import Combine

class ChatGPTViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var advice = ""
    static let shared = ChatGPTViewModel()
    
    private init() {
    }
    
    func hasAdvice() -> Bool {
        return !advice.isEmpty
    }
    
    func emptyAdvice() {
        advice = ""
    }
    
    func getMealPlanAdvice(mealPlan: String, age: Int, sex: String){
        ChatRequestManager.shared.makeRequest(mealPlan: mealPlan, age: age, sex: sex, type: ChatResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("chatGPT Error is \(err.localizedDescription)")
                case .finished:
                    print("chatGPT advice Finished")
                    
                }
            }
    receiveValue: { [weak self] response in
        if response.choices.count > 0 {
            let answer = response.choices[0].text
            self?.advice =  answer
        }
    }
    .store(in: &self.cancellables)
    }
}
