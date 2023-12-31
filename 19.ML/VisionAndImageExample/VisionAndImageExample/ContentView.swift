//
//  ContentView.swift
//  VisionAndImageExample
//

import SwiftUI
import PhotosUI
import Vision
import VisionKit

struct ContentView: View {
    @State var selectedItem: PhotosPickerItem?
    @State var uiImage: UIImage?
    @State var resultStr: String?
    @State var bounds: [CGRect] = []
    @State var imageSize: CGSize?
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 12) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "photo")
                    }.onChange(of: selectedItem) { oldValue, newValue in
                        bounds = []
                        resultStr = nil
                    }
                    
                    Button("Classify") {
                        classifyImage()
                    }
                    
                    Button("Rectange") {
                        detectRectangle()
                    }
                    
                    Button("Face Detect") {
                        detectFace()
                    }
                    
                    Button("Animal") {
                        detectAnimal()
                    }
                    
                    Spacer()
                }
                .frame(height: 60)
                Spacer()
            }
            
            ZStack {
                if let image = uiImage {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        BoxOverlay(bounds: bounds, imageSize: image.size)
                    }
                }
                
                if let result = resultStr {
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(result)
                            .font(.caption)
                            .padding()
                            .background(.yellow)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .padding(.top, 60)
            .compositingGroup()
        }
        .padding()
        .task(id: selectedItem, {
            if let loaded = try? await selectedItem?.loadTransferable(type: Data.self) {
                uiImage = UIImage(data: loaded)
            }
        })
    }
    
    func classifyImage() {
        guard let cgImage = uiImage?.cgImage else {
            return
        }
        let request = VNClassifyImageRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage)
        do {
            try handler.perform([request])
            
            guard let observations: [VNClassificationObservation] = request.results, observations.count > 0 else {
                resultStr = "No observation"
                return
            }
            
            let mapped = observations
                .filter { item in
                    item.confidence > 0.5
                }
                .sorted { lhs, rhs in
                    lhs.confidence > rhs.confidence
                }
                .map { item in
                    "\(item.identifier)(\(item.confidence))"
                }
                resultStr = mapped.joined(separator: "\n")
        }
        catch {
            // 시뮬레이터 동작 안함
            print("Error ", error)
            resultStr = "ERROR!\n\(error.localizedDescription)"
            return
        }
    }
    
    
    func detectRectangle() {
        guard let cgImage = uiImage?.cgImage else {
            return
        }
        
        let request = VNDetectRectanglesRequest()
        request.minimumConfidence = 0.6
        request.maximumObservations = 10
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        do {
            try handler.perform([request])
            
            guard let observations = request.results, observations.count > 0 else {
                resultStr = "No observation"
                return
            }
            
            let filtered = observations.filter { item in
                item.confidence > 0.6
            }
            
            bounds = filtered.map { item in
                item.boundingBox
            }
            
            resultStr = filtered.map { item in
                return "[\(item.boundingBox) ( \(item.confidence) )"
            }.joined(separator: "\n")
        }
        catch {
            print("Error", error)
            resultStr = "ERROR!\n\(error.localizedDescription)"
        }
    }
    
    func detectFace() {
        guard let cgImage = uiImage?.cgImage else {
            return
        }
        
        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try handler.perform([request])
            
            guard let observations = request.results, observations.count > 0 else {
                resultStr = "No observation"
                return
            }
            
            let filtered = observations.filter { $0.confidence > 0.6 }
            
            bounds = filtered.map { item in
                item.boundingBox
                
            }
            
            resultStr = filtered.map { item in
                return "[\(item.boundingBox) ( \(item.confidence) )"
            }.joined(separator: "\n")
        }
        catch {
            print("Error", error)
            resultStr = "ERROR!\n\(error.localizedDescription)"
        }
    }
    
    func detectAnimal() {
        guard let cgImage = uiImage?.cgImage else {
            return
        }
        
        let request = VNRecognizeAnimalsRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try handler.perform([request])
            
            guard let observations = request.results, observations.count > 0 else {
                resultStr = "No Observations"
                return
            }
            
            let filtered = observations.filter { $0.confidence > 0.6 }
            
            bounds = filtered.map { $0.boundingBox }
            
            resultStr = filtered.map { "[\($0.boundingBox) ( \($0.confidence) )" }.joined(separator: "\n")
        }
        catch {
            print("Error", error)
            resultStr = "ERROR!\n\(error.localizedDescription)"
        }
    }
    
    func detectText() {
        guard let cgImage = uiImage?.cgImage else { return }
        
        let request = VNRecognizeTextRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try handler.perform([request])
            
            guard let observations: [VNRecognizedTextObservation] = request.results, observations.count > 0 else {
                resultStr = "No Observations"
                return
            }
            
            let filtered = observations.filter { $0.confidence > 0.6 }
            
            bounds = filtered.map { $0.boundingBox }
            
            resultStr = filtered.map { item in
                let top: VNRecognizedText = item.topCandidates(1).first!
                return top.string
            }.joined(separator: "\n")
            
        }
        catch {
            print("Error", error)
            resultStr = "ERROR!\n\(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}
