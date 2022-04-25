import SwiftUI

struct PageContentView : View {
    
    /// manage user progress
    @ObservedObject private var appState: AppState
    
    /// currently opend page
    var currentPage : Page {
        BasicsCourse[appState.currentPage]
    }
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            pageHeader
            
            Rectangle()
                .cornerRadius(6)
                .foregroundColor(Color(uiColor: UIColor.secondarySystemBackground))
                .frame(height: 2)
                .padding(.top, 25)
                .padding(.bottom, 15)
            
            pageContent
        }
        .padding(30)
        .padding(.top, 15)
    }
    
    
    /// used for element spacing
    let spacingValue : CGFloat = 16
    /// used for extra topSpacing and bottomSpacing
    let topBottomSpacingValue : CGFloat = 22
    
    //  MARK: pageContent
    /// scrollable view that contains all PageElements of that page
    var pageContent : some View {
        ScrollView(showsIndicators: false){
            ScrollViewReader { value in
                VStack(alignment: .leading, spacing: spacingValue){
                    ForEach(currentPage.elements, id: \.self.id) { element in
                        
                        // Page dawing "engine"
                        
                        // Draw PageSubTitle elements
                        if let pageHeadline = element as? PageHeadline {
                            Text(pageHeadline.text)
                                .font(.body.bold())
                                .lineSpacing(3.5)
                                .padding(.top, pageHeadline.topSpacing ? topBottomSpacingValue : 0)
                                .padding(.bottom, pageHeadline.bottomSpacing ? topBottomSpacingValue : 0)
                        }
                        
                        // Draw PageText elements
                        if let pageText = element as? PageText {
                            Text(pageText.text)
                                .lineSpacing(3.5)
                                .font(.callout)
                                .padding(.top, pageText.topSpacing ? topBottomSpacingValue : 0)
                                .padding(.bottom, pageText.bottomSpacing ? topBottomSpacingValue : 0)
                        }
                        
                        // Draw PageImage elements
                        if let pageImage = element as? PageImage {
                            Image(pageImage.imageName)
                                .resizable()
                                .scaledToFit()
                                .padding(.top, pageImage.topSpacing ? topBottomSpacingValue : 0)
                                .padding(.bottom, pageImage.bottomSpacing ? topBottomSpacingValue : 0)
                        }
                        
                        // Draw PageDivider elements
                        if let pageDivider = element as? PageDivider {
                            divider
                                .padding(.top, pageDivider.topSpacing ? topBottomSpacingValue : 0)
                                .padding(.bottom, pageDivider.bottomSpacing ? topBottomSpacingValue : 0)
                        }
                        
                        // Draw PageTask elements
                        if let pageTask = element as? PageTask {
                            HStack{
                                Rectangle()
                                    .foregroundColor(.accentColor)
                                    .frame(width: 5)
                                    .cornerRadius(10)
                                    .padding(1)
                                VStack(alignment: .leading){
                                    Text("Challenge")
                                        .lineSpacing(3.5)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    Text(pageTask.text)
                                        .font(.callout)
                                        .padding(.top, 2)
                                    
                                    if let subTasks = pageTask.subTasks {
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(Color.clear)
                                        
                                        ForEach(subTasks, id: \.self) { subTask in
                                            HStack(alignment: .top){
                                                Text("•")
                                                //.padding(.leading, 6)
                                                    .padding(.trailing, 6)
                                                Text(subTask)
                                                    .font(.callout)
                                                    .lineSpacing(3)
                                            }
                                            .padding(.top, 2)
                                        }
                                    }
                                }
                                .padding(5)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                            .padding(.top, pageTask.topSpacing ? topBottomSpacingValue : 0)
                            .padding(.bottom, pageTask.bottomSpacing ? topBottomSpacingValue : 0)
                            
                        }
                        
                        // Draw PageCustomView elements
                        if let pageCustomView = element as? PageCustomView {
                            switch pageCustomView.customView {
                            case ContentCustomView.fontsContentCustomView:
                                FontsContentCustomView()
                                    .padding(.top, pageCustomView.topSpacing ? topBottomSpacingValue : 0)
                                    .padding(.bottom, pageCustomView.bottomSpacing ? topBottomSpacingValue : 0)
                            }
                        }
                    }
                    .onChange(of: appState.currentPage, perform: { x in
                        value.scrollTo(currentPage.elements.first!.id, anchor: .center)
                    })
                }
                //compensate missing VStack spacing top and bottom
                .padding(.top, spacingValue)
                .padding(.bottom, spacingValue)
                
                
                
                // show footer navigation only if not on last page
                if appState.currentPage + 1 < BasicsCourse.count {
                    divider
                    navigationButtons
                        .padding(.bottom, spacingValue)
                }
            }
            
        }
        .transition(.slide)
    }
    
    // MARK: navigationButtons
    /// navigation buttons for going back and forth in the pages, buttons will only be displayed if nagivagtion possible
    var  navigationButtons : some View {
        VStack{
            if appState.currentPage + 1 < BasicsCourse.count {
                Button {
                    //appState.appendToCompletionProgress(id: currentPage.id)
                    appState.currentPage += 1
                } label: {
                    Spacer()
                    Text("Next lesson")
                        .fontWeight(.medium)
                        .padding(5)
                    Spacer()
                }
                .padding(10)
                .background(Color(uiColor: UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.bottom, appState.currentPage - 1 < 0 ? 10 : 0 )
                .keyboardShortcut(.downArrow, modifiers: [])
            }
            
            // show back button
            if appState.currentPage - 1 >= 0 {
                Button {
                    appState.currentPage -= 1
                } label: {
                    Spacer()
                    Text("Previous")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(13)
                .keyboardShortcut(.upArrow, modifiers: [])
            }
        }
        .padding(.top, 15)
    }
    
    // MARK: divider
    /// darws a thin line with some spacign
    var divider: some View {
        Rectangle()
            .cornerRadius(6)
            .foregroundColor(Color(uiColor: UIColor.secondarySystemBackground))
            .frame(height: 2)
    }
    
    //  MARK: pageHeader
    /// shows icon, page number and title of the page
    var pageHeader: some View {
        VStack(spacing: 0){
            HStack{
                Spacer()
                Image(systemName: currentPage.titleImageName)
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
                Text(currentPage.contentSubTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 7)
                Text(currentPage.contentTitle)
                    .font(.title2).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
        }
    }
}
