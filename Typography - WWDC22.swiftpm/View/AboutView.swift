import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{
                Spacer()
                Image(systemName: "signature")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(
                        Color.accentColor
                            .cornerRadius(15)
                    )
                Spacer()
            }
            
            VStack(spacing: 6){
                Text("About this app")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 7)
                Text("Typography Basics Crashcourse")
                    .font(.title2).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            .padding(.bottom, 60)
            
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 35){
                    CalloutView(
                        systemName: "swift",
                        text: "This app was created as a submission for the Apple WWDC22 Swift Student Challenge by Henri Bredt in April 2022. To figure out how capable the iPad and the Swift Playgrounds app are, I have coded the app entirely on iPad. This year's WWDC is still ahead, looking forward to seeing you there and all the good new stuff!"
                    )
                    
                    CalloutView(
                        systemName: "person.crop.circle",
                        text: "I am a self-taught Swift developer and user experience design student with a passion for creating meaningful, simple and long-lasting products. Learn more about me on my [website](https://www.henribredt.de)."
                    )
                    
                    CalloutView(
                        systemName: "book.closed.fill",
                        text: "During the creation of this app project I used the following resources as inspiration and for reference: [Typography Tutorial - 10 rules to help you rule type](https://www.youtube.com/watch?v=QrNi9FmdlxY), [Summary of key rules (Typography)](https://practicaltypography.com/summary-of-key-rules.html), [The Beginner's Guide to Typography in Web Design](https://blog.hubspot.com/website/website-typography), [Thinking with Type](https://www.amazon.de/-/en/Ellen-Lupton-ebook/dp/B07PQ9VP3Q/)"
                    )
                }
                .padding(.leading, 35)
                .padding(.trailing, 35)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Dismiss")
                    .padding(12)
                    .padding(.leading, 6)
                    .padding(.trailing, 6)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding(60)
    }
    
}

// MARK: Callout View
struct CalloutView: View {
    var systemName: String
    var text: String
    
    var body: some View {
        HStack(alignment: .top){
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.accentColor)
                .frame(width: 20, height: 20)
                .padding(10)
                .background(
                    Color.accentColor.opacity(0.1)
                        .cornerRadius(10)
                )
                .padding(.trailing, 20)
            Text(try! AttributedString(markdown: text))
                .font(.footnote)
                .lineSpacing(1.1)
        }
    }
}

// MARK: String extension: toMarkdown()
extension String {
  func toMarkdown() -> AttributedString {
    do {
      return try AttributedString(markdown: self)
    } catch {
      print("Error parsing Markdown for string \(self): \(error)")
      return AttributedString(self)
    }
  }
}
