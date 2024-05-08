//
//  ContentView.swift
//  WordScramble
//
//  Created by Berserk on 07/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var allWords = [String]()
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    // MARK: - Views
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
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
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Restart") {
                    restart()
                }
            }
            .navigationTitle(rootWord)
            .onSubmit {
                addNewWord()
            }
            .onAppear(perform: {
                startGame()
            })
        }
    }
    
    // MARK: - Core Methods
    
    func addNewWord() {
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer != rootWord else {
            presentAlert(title: "Nice try ! 😵‍💫", message: "The purpose of the game is to create different words with the letters of the one proposed.")
            return }
        
        guard answer.count > 2 else { 
            presentAlert(title: "Too short", message: "Words must contain at least 3 letters.")
            return }
        
        guard isExistingWord(answer) else {
            presentAlert(title: "Not recognized", message: "You can't just make up new words, please refer to dictionnaries 😜.")
            return }
        
        guard isNotUsed(answer) else {
            presentAlert(title: "Already used", message: "You already added this word, try another one !")
            return }
        
        guard isPossible(answer) else { 
            presentAlert(title: "Not possible", message: "You can't spell that word with the letters from \(rootWord).")
            return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func isExistingWord(_ word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isNotUsed(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(_ word: String) -> Bool {
        
        var tempWord = rootWord
        
        for letter in word {
            if let index = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func presentAlert(title: String, message: String) {
        
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func startGame() {
        guard let url = Bundle.main.url(forResource: "start", withExtension: "txt") else { return }
        
        do {
            let string = try String(contentsOf: url)
            let allWords = string.components(separatedBy: "\n")
            self.allWords = allWords
            restart()
        } catch {
            fatalError("There was an error getting start.txt")
        }
    }
    
    func restart() {
        
        rootWord = allWords.randomElement() ?? "silkworm"
        usedWords = []
    }
}

#Preview {
    ContentView()
}
