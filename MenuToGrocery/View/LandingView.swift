//
//  LandingView.swift
//  Unit 9 Content
//
//  Created by Mom macbook air on 3/29/23.
//

import SwiftUI

struct LandingView: View {
    @ObservedObject var viewModel = LandingViewModel.shared
    @State var recipeSearchPhrase = ""
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                TextField("Enter recipe name", text: $recipeSearchPhrase)
                    .padding(.leading, 50)
                
                Button(action: {
                    viewModel.getRecipe(search: recipeSearchPhrase)
                },
                       label: {
                    Text("Search")
                        .bold()
                })
                .padding(.trailing, 30)
            }
            .padding(.top, 10)
            .padding(.bottom,10)
            .border(.blue)
            .padding(30)
            
                       
            Text("Hello, search for \(recipeSearchPhrase)")
            
            if viewModel.dishName != "" {
                List{
                    ForEach(viewModel.result.hits) { hit in
                        VStack {
                            Text("\(hit.recipe.label)")
                            AsyncImage(url: URL(string: "\(hit.recipe.image)"))
                                .scaledToFit()
                                .frame(width: UIScreen.screenWidth - 200)
                        }
                    }
                }
            }
        }
        
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
