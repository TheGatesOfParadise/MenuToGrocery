


//code is referenced from https://medium.com/geekculture/custom-top-tab-bar-in-ios-swift-swiftui-93e4fc3e5d5b
import SwiftUI

struct SplitView: View {
    let recipe:Recipe
    
    @State var tabIndex = 0
    
    var body: some View {
        VStack{
            CustomTopTabBar(tabIndex: $tabIndex)
            if tabIndex == 0 {
                FirstView(recipe:recipe)
            }
            else {
                SecondView(recipe:recipe)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
        .padding(.horizontal, 12)
    }
}

struct FirstView: View{
    let recipe:Recipe
    var body: some View{
        ZStack{
            List {
                Section("Ingredients") {
                    ForEach(recipe.ingredients) { ingredient in
                        VStack{
                            Text(ingredient.text.capitalized)
                                .foregroundColor(.blue)
                                .bold()
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding([.leading,.trailing],10 )
        }
    }
}

struct SecondView: View{
    @State var showInstruction = true
    let recipe:Recipe
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(.yellow)
            WebView(url: URL(string: recipe.url)!, showWebView: $showInstruction)
        }
    }
}

struct CustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        VStack {
            //Image(systemName: "arrow.up.arrow.down.square")
            Rectangle()
                .frame(width:100, height:5)
                .foregroundColor(.gray)
                .padding([.top], 5)
            HStack(spacing: 20) {
                Spacer()
                TabBarButton(text: "Ingredients", isSelected: .constant(tabIndex == 0))
                    .onTapGesture { onButtonTapped(index: 0) }
                Spacer()
                TabBarButton(text: "Instructions", isSelected: .constant(tabIndex == 1))
                    .onTapGesture { onButtonTapped(index: 1) }
                Spacer()
            }
            .border(width: 1, edges: [.bottom], color: .black)
            
            
        }
        
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
        //.font(.custom("Avenir", size: 16))
            .font(.system(size: 16))
            .padding(.bottom,10)
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: .black)
    }
}

struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}


struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView(recipe: Recipe.sample(index: 0))
    }
}
