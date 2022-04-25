import SwiftUI

struct HierarchyPlaygroundView: View {        
    // manage user progress
    @ObservedObject var appState: AppState
    
    // title
    @State private var titleFontSize : CGFloat = 21.0
    @State private var titleWeight : Font.Weight = .light
    
    var body: some View {
        VStack() {
            Image(uiImage: #imageLiteral(resourceName: "iphone.png")).resizable().scaledToFit()
                .background(
                    HierarchyAppView(titleFontSize: $titleFontSize, titleWeight: $titleWeight)
                        .padding(33)
                        .padding(.top, 20)
                )
                .padding(.bottom, 5)
            
            
            VStack(spacing: 15){
                FontSizeSelector(fontSize: $titleFontSize)
                    .padding()
                    .background(
                        Color(uiColor: .secondarySystemBackground)
                    )
                    .cornerRadius(10)
                FontWeightSelector(fontWeight: $titleWeight)
                    .padding()
                    .background(
                        Color(uiColor: .secondarySystemBackground)
                    )
                    .cornerRadius(10)
            }
            .padding(.top)
            .onChange(of: titleFontSize) { newValue in
                checkChallengeCompleted()
            }
            .onChange(of: titleWeight) { newValue in
                checkChallengeCompleted()
            }
        }
    }
    
    func checkChallengeCompleted(){
        if (titleWeight == .heavy || titleWeight  == .bold) && (titleFontSize > 31 && titleFontSize < 41) {
            /// currently opend page
            let currentPage = BasicsCourse[appState.currentPage]
            // Mark lesson as completed
            appState.appendToCompletionProgress(id: currentPage.id)
        }
    }
}

struct HierarchyAppView: View {
    
    @Binding var titleFontSize : CGFloat
    @Binding var titleWeight : Font.Weight
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                
                Text("News Online")
                    .font(.system(size: titleFontSize, design: .default)).fontWeight(titleWeight)
                    .fontWeight(.bold)
                    .lineSpacing(0)
                    .padding(.bottom, 0.5)
                
                ForEach(["Economics", "Technology", "Sports", "All categories"], id: \.self) { category in
                    HStack{
                        Text(category)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                
                Text("Top Stories")
                    .font(.system(size: titleFontSize-10, design: .default)).fontWeight(titleWeight)
                    .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 4){
                    Text("2h ago • Technology")
                        .font(.caption)
                    Text("Apple introduces next generation M1 Max chip beating out the competition")
                        .font(.headline)
                    Text("With the M1 Max Apple combined two M1 Pro chiüs with a custom bridge between them, letting the two SOC's appear as a single compting unit. This groundbraking technology is shocking the chip industry.")
                        .font(.caption)
                }
                .padding(.top, 1)
                
                VStack(alignment: .leading, spacing: 4){
                    Text("8h ago • Technology")
                        .font(.caption)
                    Text("Apple announces WWDC22 online event with public viewing at Apple Park")
                        .font(.headline)
                    Text("This morning Apple announced it will host its annual Worldwide Developers Conference this year again in an online format from June 6 through 10, free for all developers to attend. WWDC22 features the latest innovations on Apple plattforms, while giving developers access to engineers and technologies to learn how to create stunning apps and interactive experiences. For the first time there will be a public viewing of the keynote at Apple Park.")
                        .font(.caption)
                }
                .padding(.top, 6)
                Spacer()
            }
        }
    }
}

struct FontSizeSelector: View {
    @Binding var fontSize: CGFloat
    
    var body: some View {
        HStack{
            if fontSize > 31 && fontSize < 41 {
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
            
            Text("Size")
                .font(.callout)
                .padding(5)
                .animation(.none, value: fontSize)
            Slider(value: $fontSize.animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5)), in: 20...50)
                .animation(.none, value: fontSize)
            Text("\(fontSize, specifier: "%.00f")")
                .monospacedDigit()
                .font(.caption)
                .padding(5)
                .animation(.none, value: fontSize)
        }
    }
}

struct FontWeightSelector: View {
    @State private var selection: Int = 0
    @Binding var fontWeight: Font.Weight
    
    var body: some View {
        HStack{
            if fontWeight == .heavy || fontWeight == .bold {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.green)
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .transition(.scale.combined(with: .opacity))
                
            } else {
                Image(systemName: "bold.underline")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.accentColor)
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Text("Weight")
                .font(.callout)
                .padding(5)
                .animation(.none, value: fontWeight)
           
            HStack(spacing: 0) {
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.accentColor)
                    .padding(.trailing, 12)
                Picker("Fontweight", selection: $selection, content: {
                    Text("Light").tag(0)
                    Text("Regular").tag(1)
                    Text("Medium").tag(2)
                    Text("Semibold").tag(3)
                    Text("Bold").tag(4)
                    Text("Heavy").tag(5)
                })
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(10)
            .onChange(of: selection) { newValue in
                switch newValue {
                case 0: fontWeight = .light
                case 1: fontWeight = .regular
                case 2: fontWeight = .medium
                case 3: fontWeight = .semibold
                case 4: fontWeight = .bold
                case 5: fontWeight = .heavy
                default: fontWeight = .regular
                }
            }
        }
        .animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5), value: fontWeight)
    }
}

