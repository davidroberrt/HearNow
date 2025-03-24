//
//  HearNowViewModel.swift
//  HearNow
//
//  Created by David Robert on 06/03/25.
//
import Foundation
import Combine

class HearNowViewModel: ObservableObject {
    @Published var transcriptionText: String = ""
    @Published var isRecording: Bool = false
    private var soundLensModel = HearNowModel()

    // Função para iniciar e parar a gravação de áudio
    func toggleRecording() {
        if isRecording {
            soundLensModel.stopRecording()
            transcriptionText = ""
        } else {
            soundLensModel.startRecording { [weak self] transcription in
                DispatchQueue.main.async {
                    self?.transcriptionText = transcription
                }
            }
        }
        isRecording.toggle()
    }
}
