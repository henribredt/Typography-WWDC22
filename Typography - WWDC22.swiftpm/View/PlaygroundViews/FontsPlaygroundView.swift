import SwiftUI

struct FontsPlaygroundView: View {
    
    // manage user progress
    @ObservedObject var appState: AppState
    
    // subtitle
    @State private var subTitleSelection = 2
    @State private var subTitleFont: Font = Font.custom("American Typewriter", size: 14).weight(.regular)
    @State private var subTitleCorrect = false
    
    // title
    @State private var titleSelection = 1
    @State private var titleFont: Font = .system(size: 25, weight: .semibold, design: .serif)
    @State private var titleCorrect = false

    // body
    @State private var bodySelection = 1
    @State private var bodyFont: Font = .system(size: 17, weight: .regular, design: .serif)
    @State private var bodyCorrect = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Spacer()
            VStack(alignment: .leading, spacing: 10){
                Text("2h ago • Technology")
                    .font(subTitleFont)
                Text("Apple announces WWDC22 online event with keynote public viewing at Apple Park")
                    .lineSpacing(1.5)
                    .font(titleFont)
                    .padding(.bottom, 12)
                Text("This morning Apple announced it will host its annual Worldwide Developers Conference this year again in an online format from June 6 through 10, free for all developers to attend. WWDC22 features the latest innovations on Apple plattforms, while giving developers access to engineers and technologies to learn how to create stunning apps and interactive experiences. For the first time there will be a public viewing of the keynote at Apple Park.")
                    .lineSpacing(2.5)
                    .font(bodyFont)
            }
            .padding()
            Spacer()
            Spacer()
            VStack(alignment: .leading){
                FontSelector(selection: $subTitleSelection, correct: $subTitleCorrect, title: "Subtitle")
                FontSelector(selection: $titleSelection, correct: $titleCorrect, title: "Title")
                FontSelector(selection: $bodySelection, correct: $bodyCorrect, title: "Body")
            }
            .onChange(of: subTitleSelection) { newValue in
                updateFont(tag: newValue, font: &subTitleFont, size: 14, weight: .regular)
                if subTitleSelection == 0 { subTitleCorrect = true } else { subTitleCorrect = false }
                checkChallengeCompleted()
            }
            .onChange(of: titleSelection) { newValue in
                updateFont(tag: newValue, font: &titleFont, size: 25, weight: .semibold)
                if titleSelection == 0 { titleCorrect = true } else { titleCorrect = false }
                checkChallengeCompleted()
            }
            .onChange(of: bodySelection) { newValue in
                updateFont(tag: newValue, font: &bodyFont, size: 17, weight: .regular)
                if bodySelection == 0 { bodyCorrect = true } else { bodyCorrect = false }
                checkChallengeCompleted()
            }
            
        }
    }
    
    func updateFont(tag: Int, font: inout Font, size: CGFloat, weight: Font.Weight){
        switch tag {
        case 0:
            font = .system(size: size, weight: weight, design: .default)
        case 1:
            font = .system(size: size, weight: weight, design: .serif)
        case 2:
            font = Font.custom("American Typewriter", size: size).weight(weight)
        case 3:
            font = .system(size: size, weight: weight, design: .monospaced)
        case 4:
            font = Font.custom("Snell Roundhand", size: size).weight(weight)
            
        default:
            font = .system(size: size, weight: weight, design: .default)
        }
    }
    
    func checkChallengeCompleted(){
        if (subTitleCorrect && titleCorrect && bodyCorrect) {
            /// currently opend page
            let currentPage = BasicsCourse[appState.currentPage]
            // Mark lesson as completed
            appState.appendToCompletionProgress(id: currentPage.id)
        }
    }
}

struct FontSelector: View {
    
    @Binding var selection: Int
    @Binding var correct: Bool
    var title: String
    
    var body: some View {
        HStack(spacing: 30){
            HStack(alignment: .center) {
                // Icon
                if (correct) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.green)
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .padding(.trailing, 4)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "character.textbox")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.accentColor)
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .padding(.trailing, 4)
                        .transition(.scale.combined(with: .opacity))
                }
                HStack{
                    Text(title)
                        .font(.callout)
                    Spacer()
                }
                .frame(width: 64)
            }
            .animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5), value: correct)
            
            HStack(spacing: 0) {
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.accentColor)
                    .padding(.trailing, 12)
                Picker(title, selection: $selection, content: {
                    Text("New York").tag(1)
                    Text("San Francisco").tag(0)
                    Text("San Francisco Mono").tag(3)
                    Text("American Typewriter").tag(2)
                    Text("Snell Roundhand").tag(4)
                })
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
