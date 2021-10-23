//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jameson Hurst on 10/21/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingGameOver = false
    
    @State private var scoreTitle = ""
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var playerScore = 0
    @State private var tapCount = 0 {
        didSet {
            if tapCount == 8 {
                showingGameOver = true
            }
        }
    }
    
    @State private var countries = countryList.shuffled()
    static let countryList = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
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
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 10)
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
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        print(countries)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        tapCount = 0
        playerScore = 0
        countries = Self.countryList
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
