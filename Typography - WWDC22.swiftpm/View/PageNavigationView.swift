import SwiftUI

struct PageNavigationView: View {
    
    public init(appState: AppState) { self.appState = appState }
    
    /// manage user progress
    @ObservedObject private var appState: AppState
    
    /// defines if the app shows the about window
    @State private var showingAboutView = false
    
    var body : some View {
        VStack(alignment: .leading, spacing: 0){
            
            courseInfoHeader
            
            Text("Lessons")
                .font(.caption).fontWeight(.medium)
                .padding(.bottom, 10)
            
            pageOverview
            
            moreButton
        }
        .padding(18)
        .padding(.top, 25)
        .background(Color(uiColor: .secondarySystemBackground))
        .animation(Animation.timingCurve(0.44, 1.86, 0.61, 0.99, duration: 0.5), value: appState.completionProgress)
        .sheet(isPresented: $showingAboutView){
            AboutView()
        }
    }
    
    
    //  MARK: courseInfoHeader
    /// contines course title and a progress bar
    var courseInfoHeader : some View {
        VStack(alignment: .leading, spacing: 4){
            Text("Typography")
                .font(.footnote)
            Text("Basics Crashcourse")
                .font(.title3).fontWeight(.semibold)
                .padding(.bottom, 20)
            ProgressView(value: Float(appState.completionProgress.count), total: Float(BasicsCourse.count))
            HStack{
                Text("\((appState.completionProgress.count) * 100 / BasicsCourse.count) % completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button {
                    appState.resetCompletionProgress()
                } label: {
                    Text("Reset progess")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
                
            }
            .padding(.top, 2)
            .padding(.bottom, 60)
        }
    }
    
    //  MARK: pageOverview
    /// shows all availabe pages in a course including its completion status and allows navigation
    var pageOverview: some View {
        VStack(alignment: .leading){
            ScrollView{
                VStack(spacing: 0){
                    ForEach(BasicsCourse, id: \.self.id) { page in
                        Button {
                            let index = BasicsCourse.firstIndex(of: page) ?? 0
                            appState.currentPage = index
                        } label: {
                            
                            HStack{
                                if (appState.completionProgress.contains(page.id)) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.green)
                                        .frame(width: 20, height: 20)
                                        .padding(5)
                                        .padding(.trailing, 4)
                                        .transition(.scale.combined(with: .opacity))
                                } else {
                                    Image(systemName: page.titleImageName)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.accentColor)
                                        .frame(width: 20, height: 20)
                                        .padding(5)
                                        .padding(.trailing, 4)
                                        .transition(.scale.combined(with: .opacity))
                                }
                                Text(page.title)
                                    .font(.callout)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(10)
                            .background(page.id == BasicsCourse[appState.currentPage].id ? Color.accentColor.opacity(0.1) : Color.clear )
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
    
    //  MARK: moreButton
    /// toggles a modal view showing background info about the app
    var moreButton: some View {
        Button {
            showingAboutView.toggle()
        } label: {
            HStack{
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.accentColor)
                    .frame(width: 17, height: 17)
                    .padding(5)
                    //.padding(.trailing, 2)
                    .transition(.scale.combined(with: .opacity))
                
                Text("About this app")
                    .font(.footnote)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
    
}
