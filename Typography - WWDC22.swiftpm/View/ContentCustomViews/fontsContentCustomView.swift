//
//  SwiftUIView.swift
//  
//
//  Created by Henri Bredt on 24.04.22.
//

import SwiftUI

struct FontsContentCustomView: View {
    @State private var selectedType = 0
    @State private var font: Font = .system(size: 30, weight: .medium, design: .default)
    @State private var text = "Font Sans Serif"
    
    var body: some View {
        VStack {
            Picker("Favorite Color", selection: $selectedType, content: {
                Text("Sans").tag(0)
                Text("Serif").tag(1)
                Text("Slab").tag(2)
                Text("Mono").tag(3)
                Text("Script").tag(4)
            })
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedType){ newValue in
                switch newValue {
                case 0:
                    font = .system(size: 30, weight: .medium, design: .default)
                    text = "Sans Serif Font"
                case 1:
                    font = .system(size: 30, weight: .medium, design: .serif)
                    text = "Serif Font"
                case 2:
                    font = Font.custom("American Typewriter", size: 30).weight(.regular)
                    text = "Slab Serif Font"
                case 3:
                    font = .system(size: 30, weight: .medium, design: .monospaced)
                    text = "Monospaced Font"
                case 4:
                    font = Font.custom("Snell Roundhand", size: 32).weight(.medium)
                    text = "Script Font"
                   
                default:
                    font = .system(size: 30, weight: .medium, design: .default)
                    text = "Font"
                }
            }
            
            Text(text)
                .font(font)
                .padding()
                .frame(height: 80)
        }
        
    }
}

