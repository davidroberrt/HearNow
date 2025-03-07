//
//  Model.swift
//  HearNowModel
//
//  Created by David Robert on 06/03/25.
//

import AVFoundation
import Speech

class HearNowModel {
    private var audioRecorder: AVAudioRecorder?
    private var recognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()

    // Função para iniciar gravação de áudio
    func startRecording(completion: @escaping (String) -> Void) {
        // Certifique-se de que a linguagem está configurada para pt-BR
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
        
        // Verificar se o idioma é suportado
        guard let recognizer = recognizer, recognizer.isAvailable else {
            print("Reconhecedor de fala não disponível ou idioma não suportado.")
            return
        }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),  // Formato de alta qualidade (Lossless)
                AVSampleRateKey: 192000,                        // Aumenta a taxa de amostragem para 96 kHz
                AVNumberOfChannelsKey: 1,                      // Mono (mais eficiente para captar sons distantes)
                AVLinearPCMBitDepthKey: 32,                    // Profundidade de 24 bits para mais detalhes
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue, // Qualidade máxima da gravação
                AVSampleRateConverterAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
                try audioSession.setActive(true)

                if audioSession.isInputGainSettable {
                    try audioSession.setInputGain(1.0) // Máximo ganho permitido (0.0 a 1.0)
                }
            } catch {
                print("Erro ao configurar sessão de áudio: \(error.localizedDescription)")
            }
            // Criando um arquivo temporário para a gravação
            let audioURL = FileManager.default.temporaryDirectory.appendingPathComponent("audioRecording.m4a")
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder?.record()

            // Iniciar o reconhecimento de fala em paralelo
            startSpeechRecognition(completion: completion)
        } catch {
            print("Erro ao iniciar gravação: \(error.localizedDescription)")
        }
    }
    
    // Função para parar a gravação de áudio
    func stopRecording() {
        // Parar o áudio recorder, o reconhecimento de fala e o audio engine
        audioRecorder?.stop()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        task?.cancel()
        
        // Reiniciar variáveis de estado
        request = nil
        task = nil
    }

    // Função para transcrever o áudio em texto
    private func startSpeechRecognition(completion: @escaping (String) -> Void) {
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = request else { return }

        // Aguardando a fala para reconhecer
        var recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let transcription = result.bestTranscription.formattedString
                completion(transcription)
            } else if let error = error {
                print("Erro no reconhecimento de fala: \(error.localizedDescription)")
            }
        }
        
        // Captura contínua de áudio usando AVAudioEngine
        let inputNode = audioEngine.inputNode
        let bus: AVAudioNodeBus = 0
        let recordingFormat = inputNode.outputFormat(forBus: bus)
        inputNode.installTap(onBus: bus, bufferSize: 1024, format: recordingFormat) { buffer, time in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }
}
