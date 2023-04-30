//
//  Test2View.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/30/23.
//

import SwiftUI

struct Test2View: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                testMerge()
            }
    }
    
    func testMerge() {
        let nums0 = [1, 7, 17, 25, 38]
        let nums1 = [2, 5, 17, 29, 31]

        let all = nums0 + nums1.reversed()

        let merged = all.reduce(into: (all, [Int]())) { (result, elm) in
            let first = result.0.first!
            let last = result.0.last!

            if first < last {
                result.0.removeFirst()
                result.1.append(first)
            } else {
                result.0.removeLast()
                result.1.append(last)
            }
        }.1

        print (merged)
    }
    
}

struct Test2View_Previews: PreviewProvider {
    static var previews: some View {
        Test2View()
    }
}
