//
//  ContentView.swift
//  WordScramble
//
//  Created by Berserk on 07/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit {
                startGame()
                addNewWord()
            }
            .onAppear(perform: {
                startGame()
            })
        }
    }
    
    func addNewWord() {
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard !usedWords.contains(answer) else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        guard let url = Bundle.main.url(forResource: "start", withExtension: "txt") else { return }
        
        do {
            let string = try String(contentsOf: url)
            let allWords = string.components(separatedBy: "\n")
            rootWord = allWords.randomElement() ?? "silkworm"
        } catch {
            fatalError("There was an error getting start.txt")
        }
    }
}

#Preview {
    ContentView()
}
