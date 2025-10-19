//
//  ContentView.swift
//  Learning
//
//  Created by lamess on 27/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack{
            Color("BackgoundColor").edgesIgnoringSafeArea(.all)
            VStack {
                Text("").statusBarHidden(false)
            }
        }
    }
}

#Preview {
    ContentView()
}
