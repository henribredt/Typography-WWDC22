import SwiftUI

struct KerningPlaygroundView: View {
    
    // manage user progress
    @ObservedObject var appState: AppState
    
    @State private var kerning = -6.0
    @State private var fontSize = 80.0
    
    var body: some View {
        VStack{
            Spacer()
            Text("Hello!")
                .bold()
                .font(.system(size: fontSize))
                .kerning(kerning)
            Spacer()
            
            // font size
            HStack{
                if fontSize > 55 && fontSize < 65 {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.green)
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .transition(.scale.combined(with: .opacity))
                    
                } else {
                    Image(systemName: "textformat.size")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.accentColor)
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Text("Font size")
                    .font(.callout)
                    .padding(5)
                    .animation(.none, value: kerning)
                Slider(value: $fontSize.animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5)), in: 25...85)
                    .animation(.none, value: kerning)
                Text("\(fontSize, specifier: "%.00f")")
                    .monospacedDigit()
                    .font(.caption)
                    .padding(5)
                    .animation(.none, value: kerning)
                
               
            }
            .padding()
            .background(
                Color(uiColor: .secondarySystemBackground)
            )
            .cornerRadius(10)
            .padding(.bottom, 5)
            
            // Kerning
            HStack{
                if kerning > 1 && kerning < 3 {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.green)
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .transition(.scale.combined(with: .opacity))
                    
                } else {
                    Image(systemName: "textformat.abc.dottedunderline")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.accentColor)
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Text("Tracking")
                    .font(.callout)
                    .padding(5)
                    .animation(.none, value: kerning)
                Slider(value: $kerning.animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5)), in: -8.0...8.0)
                    .animation(.none, value: kerning)
                Text("\(kerning, specifier: "%.00f")")
                    .monospacedDigit()
                    .font(.caption)
                    .padding(5)
                    .animation(.none, value: kerning)
                
                
            }
            .padding()
            .background(
                Color(uiColor: .secondarySystemBackground)
            )
            .cornerRadius(10)
            
        }
        .onChange(of: kerning) { newValue in
            checkChallengeCompleted()
        }
        .onChange(of: fontSize) { newValue in
            checkChallengeCompleted()
        }
    }
    
    func checkChallengeCompleted(){
        if (kerning > 1 && kerning < 3) && (fontSize > 55 && fontSize < 65) {
            /// currently opend page
            let currentPage = BasicsCourse[appState.currentPage]
            // Mark lesson as completed
            appState.appendToCompletionProgress(id: currentPage.id)
        }
    }
}

