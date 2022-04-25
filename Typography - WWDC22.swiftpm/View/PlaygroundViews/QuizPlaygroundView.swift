import SwiftUI

struct QuizPlaygroundView: View {
    
    init(appState: AppState){
        self.appState = appState
    }
    
    // manage user progress
    @ObservedObject var appState: AppState
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var quizCompleted = false
    @State private var showingHUD = false
    @State private var currentQuestionIndex = 0
    @State private var currentAnswerIsCorrect = false
    @State private var currentAnswerIsFalse = false
    @State private var isAnimating = false
    
    @State var animateShake: Int = 0
    
    // Quiz data
    private var questions = ["If you wanted to design the text on a website, what font would you choose?", "Which statement is wrong?", "Too much tracking causes a text to become difficult to read because letters overlap."]
    private var answers = [["Slab Serif", "Mono spaced", "Sans Serif", "Serif"],["Digital body text should be larger than 13 px", "The combination of semibold and bold font weights create good hierarchy", "When subheadlines have a font size of 20px, 40px would be a good size for headlines", "_empty_"],["True", "False", "_empty_", "_empty_"]]
    private var correctAnswers = [2,1,1]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(){
                if !quizCompleted {
                    HStack{
                        Spacer()
                        VStack{
                            Text("Question \(currentQuestionIndex+1) of \(questions.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 8)
                                
                            Text(questions[currentQuestionIndex])
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.primary)
                                .font(.title3)
                                .transition(.scale)
                                .lineSpacing(1.5)
                                .modifier(ShakeEffect(animatableData: CGFloat(animateShake))) // Shake on wrong input
                        }
                        .padding(30)
                        Spacer()
                    }
                    .frame(height: 250)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    
                    
                    VStack{
                        ForEach(0..<4) { index in
                            if answers[currentQuestionIndex][index] != "_empty_" {
                                Button {
                                    if index == correctAnswers[currentQuestionIndex] {
                                        currentAnswerIsCorrect = true
                                        currentAnswerIsFalse = false
                                    } else {
                                        currentAnswerIsCorrect = false
                                        currentAnswerIsFalse = true
                                    }
                                    
                                    withAnimation(Animation.timingCurve(0.47, 1.62, 0.45, 0.99, duration: 0.4)) {
                                        showingHUD.toggle()
                                        isAnimating = true
                                    }
                                    
                                    
                                    // Auto dismiss HUD
                                    if (!currentAnswerIsCorrect) {
                                        withAnimation(.default) {
                                            animateShake += 1
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + (2.5) ) {
                                            withAnimation() {
                                                showingHUD = false
                                                isAnimating = false
                                                currentAnswerIsFalse = false
                                            }
                                        }
                                        //Dismiss and show next question
                                    } else {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + (1.7) ) {
                                            nextQuestion()
                                            withAnimation() {
                                                showingHUD = false
                                                isAnimating = false
                                                currentAnswerIsFalse = false
                                            }
                                        }
                                    }
                                    
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text(answers[currentQuestionIndex][index])
                                            .font(.callout)
                                            .foregroundColor(.accentColor)
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color.accentColor.opacity(0.13))
                                    .cornerRadius(10)
                                }
                                .padding(3)
                            }
                            
                        }
                        .disabled(isAnimating)
                        
                    }
                    .padding(.top, 35)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity) )
                    Spacer()
                    
                } else {
                    // Quiz was completed
                    completedView
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity) )
                }
            }
            
            if showingHUD {
                HUD {
                    if (currentAnswerIsCorrect) {
                        HStack(spacing: 25) {
                            HStack{
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("That's correct")
                                    .padding(.leading, 5)
                                    .foregroundColor(Color.primary)
                            }
                        }
                    } else {
                        HStack{
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("That's wrong, try again")
                                .padding(.leading, 5)
                        }
                    }
                }
                .zIndex(1)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            withAnimation {
                showingHUD = false
                isAnimating = false
                currentAnswerIsCorrect = false
            }
        } else {
            // mark as finished
            let currentPage = BasicsCourse[appState.currentPage]
            appState.appendToCompletionProgress(id: currentPage.id)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.01) ) {
                withAnimation(Animation.timingCurve(0.65, 0, 0.35, 1, duration: 0.4)){
                    quizCompleted = true
                }
                currentQuestionIndex = 0
            }
        }
        
    }
    
    var completedView: some View {
        HStack{
            Spacer()
            VStack(spacing: 20){
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.largeTitle)
                Text("Congratulations, you have successfully completed the quiz")
                    .padding(.leading, 5)
                    .foregroundColor(Color.primary)
                    .font(.title3.weight(.medium))
                    .multilineTextAlignment(.center)
                Button {
                    withAnimation(Animation.timingCurve(0.65, 0, 0.35, 1, duration: 0.4)) {
                        quizCompleted = false
                    }
                } label: {
                    Text("Restart")
                        .padding(12)
                        .padding(.leading, 7)
                        .padding(.trailing, 7)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.top, 50)
                
            }
            Spacer()
        }
    }
}



struct HUD<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(16)
            .background(
                Capsule()
                    .foregroundColor(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) :  Color(UIColor.systemBackground))
                    .shadow(color: Color(.black).opacity(0.15), radius: 10, x: 0, y: 4)
            )
            .padding(20)
    }
}


// Shake effect for wrong input of textfields
// inspired by: https://www.objc.io/blog/2019/10/01/swiftui-shake-animation/
// to achieve the shake, implemented a modified version
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                10 * sin(animatableData * .pi * CGFloat(3)),
                                              y: 0)
        )
    }
}
