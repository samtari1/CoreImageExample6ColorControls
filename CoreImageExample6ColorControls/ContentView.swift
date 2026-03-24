//
//  ContentView.swift
//  CoreImageExample6ColorControls
//
//  Created by Quanpeng Yang on 3/23/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var originalImage = UIImage(named: "mountain") ?? UIImage(systemName: "photo.fill")!
    @State private var filteredImage: UIImage?
    
    // Default values for ColorControls
    @State private var brightness: Float = 0.0  // Range: -1.0 to 1.0
    @State private var contrast: Float = 1.0    // Range: 0.0 to 4.0 (1.0 is neutral)
    @State private var saturation: Float = 1.0  // Range: 0.0 to 2.0 (1.0 is neutral)
    
    let context = CIContext()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Color Adjustments")
                    .font(.title2.bold())

                Image(uiImage: filteredImage ?? originalImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)

                VStack(spacing: 20) {
                    controlSlider(label: "Brightness", value: $brightness, range: -0.5...0.5)
                    controlSlider(label: "Contrast", value: $contrast, range: 0.0...2.0)
                    controlSlider(label: "Saturation", value: $saturation, range: 0.0...2.0)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(15)

                Button("Reset Defaults") {
                    brightness = 0.0
                    contrast = 1.0
                    saturation = 1.0
                    applyColorControls()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .onAppear { applyColorControls() }
    }

    // Helper to keep the UI code clean
    func controlSlider(label: String, value: Binding<Float>, range: ClosedRange<Float>) -> some View {
        VStack(alignment: .leading) {
            Text("\(label): \(String(format: "%.2f", value.wrappedValue))")
                .font(.caption.monospacedDigit())
            Slider(value: value, in: range)
                .onChange(of: value.wrappedValue) { applyColorControls() }
        }
    }

    func applyColorControls() {
        let filter = CIFilter.colorControls()
        guard let inputCIImage = CIImage(image: originalImage) else { return }
        
        filter.inputImage = inputCIImage
        filter.brightness = brightness
        filter.contrast = contrast
        filter.saturation = saturation
        
        if let outputImage = filter.outputImage {
            // Color controls don't change image size, so input.extent is perfect
            if let cgImage = context.createCGImage(outputImage, from: inputCIImage.extent) {
                filteredImage = UIImage(cgImage: cgImage)
            }
        }
    }
}
