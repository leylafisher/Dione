//
//  KeyboardView.swift
//  Keyboard
//
//  Created by Renzo Alvaroshan on 22/01/23.
//

import KeyboardKit
import SwiftUI

struct KeyboardView: View {
    
    @EnvironmentObject
    private var autocompleteContext: AutocompleteContext
    
    @EnvironmentObject
    private var keyboardContext: KeyboardContext
    
    var body: some View {
        VStack(spacing: 0) {
            if keyboardContext.keyboardType != .emojis {
                autocompleteToolbar
            }
            SystemKeyboard()
        }
    }
}

// MARK: - Private Views

private extension KeyboardView {
    
    var autocompleteToolbar: some View {
        
        AutocompleteToolbar(
            suggestions: autocompleteContext.suggestions,
            locale: keyboardContext.locale,
            action: { suggestion in
                searchFromOpenAi(suggestion)
            }).opacity(keyboardContext.prefersAutocomplete ? 1 : 0)
    }
    
    private func searchFromOpenAi(_ suggestion: AutocompleteSuggestion) {
        let controller = KeyboardInputViewController.shared
        let proxy = controller.textDocumentProxy
        let actionHandler = controller.keyboardActionHandler
        proxy.insertSearchedAutocompleteSuggestion(suggestion)
        actionHandler.handle(.tap, on: .character(""))
    }
}

public extension UITextDocumentProxy {
    
    func searchCurrentWord(with replacement: String) {
        guard let word = currentWord else { return }
        let offset = currentWordPostCursorPart?.count ?? 0
        adjustTextPosition(byCharacterOffset: offset)
        deleteBackward(times: word.count)
        print("I searched \(word) from Open AI")
        insertText(replacement)
    }
    
    func insertSearchedAutocompleteSuggestion(_ suggestion: AutocompleteSuggestion, tryInsertSpace: Bool = true) {
        searchCurrentWord(with: suggestion.additionalInfo["answer"] as! String)
        guard tryInsertSpace else { return }
        tryInsertSpaceAfterAutocomplete()
    }
    
    var wordsInsideParentheses: String? {
        
        let pre = currentWordPreCursorPart
        let post = currentWordPostCursorPart
        if pre == nil && post == nil { return nil }
        
        let text = (pre ?? "") + (post ?? "")
        var allText = ""
        
        let pattern = "\\((.*?)\\)"
        var word: Substring = Substring()

        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            for match in matches {
                let range = match.range(at: 1)
                word = text[Range(range, in: text)!]
                print(word)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
        return String(word)
    }
}
