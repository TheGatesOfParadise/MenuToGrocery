//
//  ContentView.swift
//  SwiftUIDrawer
//
//  Created by Afraz Siddiqui on 5/27/21.
//
//referenced from :https://www.youtube.com/watch?v=MnOq0VuUZ6A&list=PL5PR3UyfTWvfgx9W8WJ9orQf6N1tx0oxN&index=64
import SwiftUI

struct RecipeView: View {
    var recipe: Recipe
    @State private var offset: CGFloat = 400
    @State private var isInitialOffsetSet = false
    var body: some View {
        ZStack {
            RecipeTopView(recipe: recipe)

            GeometryReader { proxy in
                ZStack {
                    // Blur
                    BlurView(style: .systemThinMaterialDark)

                    SplitView(recipe: recipe)
                }
            }
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let startLocation = value.startLocation
                        offset = startLocation.y + value.translation.height
                    }
            )
            .onAppear {
                if !isInitialOffsetSet {
                    offset = UIScreen.main.bounds.height - 400
                    isInitialOffsetSet = true
                }
            }
        }
        
    }
}


// Blurred View
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(
            //effect: UIBlurEffect(style: style)
            effect: UIBlurEffect(style: .light)
        )

        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // do nothing
    }
}


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe.sample(index: 0))
    }
}
