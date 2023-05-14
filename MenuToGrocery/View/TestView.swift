//
//  TestView.swift
//  MenuToGrocery
//
//  Created by Scarlett Ruan on 5/7/23.
//

import SwiftUI

struct TestView: View {
    @State var isPresented = false
    
    var body: some View {
        
        Button {
            isPresented = true
        } label: {
            Image("advice")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.trailing)
        }
        .sheet(isPresented: $isPresented) {
            AdviceView()
                .presentationDetents([.large])
        }
        
        Capsule()
            .fill(Color.secondary)
            .frame(width: 30, height: 3)
            .padding(10)
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
