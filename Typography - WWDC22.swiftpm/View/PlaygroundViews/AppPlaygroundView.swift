import SwiftUI

struct AppPlaygroundView: View {
    
    // manage user progress
    @ObservedObject var appState: AppState
    
    @State private var articleAlignment : HorizontalAlignment = .leading
    @State private var alignmentIndex = 1
    
    var body: some View {
        let currentPage = BasicsCourse[appState.currentPage]
        
        VStack() {
            Image(uiImage: #imageLiteral(resourceName: "iphone.png")).resizable().scaledToFit()
                .background(
                    AppView(articleAlignment: $articleAlignment)
                        .padding(30)
                        .padding(.top, 18)
                )
            
            Picker(selection: $alignmentIndex, label: EmptyView()) {
                Image(systemName: "align.horizontal.left.fill").tag(0)
                Image(systemName: "align.horizontal.center.fill").tag(1)
                Image(systemName: "align.horizontal.right.fill").tag(2)
            }
            .pickerStyle(.segmented) 
            .padding(.leading)
            .padding(.trailing)
            .padding(.top)
         
            
            Color(uiColor: .secondarySystemBackground)
                .cornerRadius(10)
         
            
            
            
            .onChange(of: alignmentIndex) { newValue in
                switch newValue {
                case 0:
                    articleAlignment = .leading
                    appState.appendToCompletionProgress(id: currentPage.id)
                case 1:
                    articleAlignment = .center
                case 2:
                    articleAlignment = .trailing
                default:
                    articleAlignment = .leading
                }
            }
        }
    }
}

struct AppView: View {
    @Binding var articleAlignment : HorizontalAlignment
    
    var body: some View {
        ScrollView {
            VStack(alignment: articleAlignment){
                
                Text("News Online")
                    .font(.system(size: 35, design: .default))
                    .fontWeight(.bold)
                    .lineSpacing(0)
                
                ForEach(["Economics", "Technology", "Sports", "All categories"], id: \.self) { category in
                    HStack{
                        Text(category)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Text("Top Stories")
                    .font(.title.bold())
                
                VStack(alignment: articleAlignment){
                    Text("2h ago • Technology")
                        .font(.caption)
                    Text("Apple introduces next generation M1 Max chip beating out the competition")
                        .font(.headline)
                    Text("With the M1 Max Apple combined two M1 Pro with a custom bridged between, letting the two SOC's appear as a single compting unit. This groundbraking technology is likely to replace my battery draining Intel i7 haha, thanks for reading that far.")
                        .font(.caption)
                }
                
                VStack(alignment: articleAlignment){
                    Text("2h ago • Technology")
                        .font(.caption)
                    Text("Apple announces WWDC22 online event with public viewing at Apple Park")
                        .font(.headline)
                    Text("With the M1 Max Apple combined two M1 Pro with a custom bridged between, letting the two SOC's appear as a single compting unit. This groundbraking technology is likely to replace my battery draining Intel i7 haha, thanks for reading that far.")
                        .font(.caption)
                }
                Spacer()
            }
        }
    }
}
