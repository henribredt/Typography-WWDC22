import SwiftUI

struct BaseView: View {
    
    /// manage user progress
    @StateObject var appState = AppState()
    
    var body: some View {
        HStack(spacing: 0){
            // Navigation
            PageNavigationView(appState: appState)
                .frame(width: 295)
            
            // Content
            PageContentView(appState: appState)
            
            // Divider
            Rectangle() 
                .foregroundColor(Color(uiColor: UIColor.secondarySystemBackground))
                .frame(width: 2)
            
            // Show the PlaygroundView
            PagePlaygroundView(appState: appState)
           
            
        }
        .ignoresSafeArea()
    }
}
