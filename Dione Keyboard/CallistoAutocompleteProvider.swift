//
//  CallistoAutocompleteProvider.swift
//  Keyboard
//
//  Created by Renzo Alvaroshan on 22/01/23.
//

import Foundation
import KeyboardKit

class CallistoAutocompleteProvider: AutocompleteProvider {
    
    init(match: String = "match") {
        self.match = match
    }
    
    private var match: String
    
    var locale: Locale = .current
    
    var canIgnoreWords: Bool { false }
    var canLearnWords: Bool { false }
    var ignoredWords: [String] = []
    var learnedWords: [String] = []
    
    func hasIgnoredWord(_ word: String) -> Bool { false }
    func hasLearnedWord(_ word: String) -> Bool { false }
    func ignoreWord(_ word: String) {}
    func learnWord(_ word: String) {}
    func removeIgnoredWord(_ word: String) {}
    func unlearnWord(_ word: String) {}
    
    func autocompleteSuggestions(for text: String, completion: @escaping AutocompleteCompletion) {
        guard text.count > 0 else { return completion(.success([])) }
        completion(.success(defaultSuggestion()))
    }
}

private extension CallistoAutocompleteProvider {
    
    func defaultSuggestion() -> [AutocompleteSuggestion] {
        [
            StandardAutocompleteSuggestion(text: "Search", additionalInfo: ["answer": "Renzo is cool"]),
        ]
    }
}


