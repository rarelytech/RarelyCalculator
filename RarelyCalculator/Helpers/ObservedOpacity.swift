//
//  ObservedOpacity.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/17.
//

import Foundation

class ObservedOpacity: ObservableObject {
    let objectWillChange = ObjectWillChangePublisher()
    
    @Published var value: Double = 1.0 {
        willSet {
            if newValue != value {
                objectWillChange.send()
            }
        }
    }
}
