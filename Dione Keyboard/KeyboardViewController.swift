//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Renzo Alvaroshan on 22/01/23.
//

import KeyboardKit
import UIKit

class KeyboardViewController: KeyboardInputViewController {
    
    override func viewDidLoad() {
        autocompleteProvider = CallistoAutocompleteProvider()
        super.viewDidLoad()
    }
    
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()
        setup(with: KeyboardView())
    }
}
