//
//  ContentView.swift
//  HearNow
//
//  Created by David Robert on 06/03/25.
//

import SwiftUI

struct SplashView: View {
    @State private var showSplash: Bool = true
    
    var body: some View {
        if showSplash == false{
            HearNowView()
        } else{
            VStack {
                Spacer()
                Image("HearNow")
                    .resizable()
                    .frame(minWidth: 400, minHeight: 400)
                Spacer()
            }
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSplash = false
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
