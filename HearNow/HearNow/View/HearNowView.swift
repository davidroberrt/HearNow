//
//  SoundLensView.swift
//  HearNowView
//
//  Created by David Robert on 06/03/25.
//

import SwiftUI

struct HearNowView: View {
    @StateObject private var viewModel = HearNowViewModel()

    var body: some View {
        VStack {
            Text("HearNow")
                .font(.largeTitle)
                .padding()

            Text(viewModel.transcriptionText.isEmpty ? "..." : viewModel.transcriptionText)
                .font(.title2)
                .padding()

            Button(action: {
                viewModel.toggleRecording()
            }) {
                Text(viewModel.isRecording ? "Parar Captura de Áudio" : "Iniciar Captura de Áudio")
                    .padding()
                    .background(viewModel.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}


#Preview {
    HearNowView()
}
