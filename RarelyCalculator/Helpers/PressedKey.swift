//
//  PressedKey.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/17.
//

import Foundation

class PressedKey: ObservableObject {
    let objectWillChange = ObjectWillChangePublisher()
    
    @Published var character = "" {
        willSet {
            objectWillChange.send()
        }
    }
}
