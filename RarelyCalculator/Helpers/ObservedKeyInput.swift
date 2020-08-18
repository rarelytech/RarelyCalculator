//
//  PressedKey.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/17.
//

import Foundation

class ObservedKeyInput: ObservableObject {
    let objectWillChange = ObjectWillChangePublisher()
    
    @Published var isKeyboardInput = false
    
    @Published var character = "" {
        willSet {
            self.isKeyboardInput = true
            objectWillChange.send()
        }
    }
}
