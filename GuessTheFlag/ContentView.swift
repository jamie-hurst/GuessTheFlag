//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jameson Hurst on 10/21/21.
//

import SwiftUI


struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingGameOver = false
    
    @State private var scoreTitle = ""
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var playerScore = 0
    @State private var tapCount = 0
    @State private var selectedFlag = -1
    
    
    @State private var countries = countryList.shuffled()
    static let countryList = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                
                VStack(spacing:40) {
                    
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                flagTapped(number)
                            }
                            
                        } label: {
                            FlagImage(image: countries[number])
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.90)
                                .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 1)
                                .animation(.default, value: selectedFlag)
                                .rotation3DEffect(.degrees(selectedFlag == number && selectedFlag == correctAnswer ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                    }
                    
                    Text("Score: \(playerScore)")
                        .foregroundStyle(.secondary)
                        .font(.headline.bold())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(playerScore)")
        }
        
        .alert("Game Over", isPresented: $showingGameOver) {
            Button("Reset Game", action: resetGame)
        } message: {
            if playerScore == 8 {
                Text("Your final score was \(playerScore). A perfect score!")
            } else {
                Text("Your final score was \(playerScore). Thank you for playing")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        tapCount += 1
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            playerScore += 1
        } else {
            scoreTitle = "Incorrect. That is the flag of \(countries[number])"
            if playerScore > 0 {
                playerScore -= 1
            }
        }
        
        if tapCount == 8 {
            showingGameOver = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
    
    func resetGame() {
        tapCount = 0
        playerScore = 0
        countries = Self.countryList
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
