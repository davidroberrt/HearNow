//
//  SoundLensView.swift
//  HearNowView
//
//  Created by David Robert on 06/03/25.
//

import SwiftUI

struct HearNowView: View {
    @StateObject private var viewModel = HearNowViewModel()
    
    @State private var scrollToBottomID = UUID()  // Identificador para rolar até o final
    
    var body: some View {
        VStack {
            Image("HearNow")
                .resizable()
                .scaledToFit()
            
            if viewModel.isRecording {
                waveform
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    Text(viewModel.transcriptionText.isEmpty ? "Play, wait and see the audition..." : viewModel.transcriptionText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor( viewModel.transcriptionText.isEmpty ? .black : .blue)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .id(scrollToBottomID)  // Identificador para rolar até o final
                        .onChange(of: viewModel.transcriptionText) {_, _ in
                            // Rola até o final sempre que o texto mudar
                            withAnimation {
                                proxy.scrollTo(scrollToBottomID, anchor: .bottom)
                            }
                        }
                }
                .foregroundStyle(.black)
            }
            .frame(maxHeight: 100)  // Limita a altura máxima da ScrollView

            
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Text(viewModel.isRecording ? "Parar Captura de Áudio" : "Iniciar Captura de Áudio")
                    .padding()
                    .background(viewModel.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}


extension HearNowView {
    var waveform: some View {
        Image(systemName: "waveform")
            .resizable()
            .frame(width: 120, height: 120)
            .symbolEffect(.variableColor.iterative.reversing)
            .symbolEffect(.breathe.byLayer)
            .foregroundStyle(.cyan)
            .padding()
    }
}


#Preview {
    HearNowView()
}
