//
//  AdviceView.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 5/2/23.
//

import SwiftUI

struct AdviceView: View {
    @ObservedObject var viewModel = MealPlanViewModel.shared
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
