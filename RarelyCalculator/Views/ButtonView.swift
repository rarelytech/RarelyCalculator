//
//  ButtonView.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/15.
//

import SwiftUI
import Combine

struct BStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.75 : 1.0)
    }
}

// code from https://stackoverflow.com/questions/61013080/how-to-do-a-simple-scaling-animation-and-why-isnt-this-working/61017784#61017784
struct ReversingOpacity: AnimatableModifier {
    var value: Double
    
    private var target: Double
    private var onEnded: () -> ()
    
    init(to value: Double, onEnded: @escaping () -> () = {}) {
        self.target = value
        self.value = value
        self.onEnded = onEnded // << callback
    }
    
    var animatableData: Double {
        get { value }
        set { value = newValue
            // newValue here is interpolating by engine, so changing
            // from previous to initially set, so when they got equal
            // animation ended
            if newValue == target {
                onEnded()
            }
        }
    }
    
    func body(content: Content) -> some View {
        content.opacity(value)
    }
}

struct ButtonView: View {
    var label: String
    var action: () -> Void
    var bgColor: Color = Color(red: 0.87, green: 0.87, blue: 0.91)
    var fgColor: Color = Color(red: 0, green: 0, blue: 0)
    var width: CGFloat = 76
    var publisher: AnyPublisher<Void, Never>?
    
    @ObservedObject var pressedKey: PressedKey
    @ObservedObject private var observedOpacity: ObservedOpacity = ObservedOpacity()
    
    var body: some View {
        
        Button(action: {
            
            self.action()
            
        }, label: {
            Text(self.label)
                .font(.system(size: 21))
                .fontWeight(.medium)
                .frame(width: self.width, height: 48, alignment: .center)
                .foregroundColor(self.fgColor)
                .background(self.bgColor)
                .cornerRadius(20, antialiased: true)
        })
        .buttonStyle(BStyle())
        .modifier(
            ReversingOpacity(to: self.observedOpacity.value) {
                self.observedOpacity.value = 1
                print(self.label, "end", self.observedOpacity.value)
            }
            .animation(.easeIn(duration: 0.05))
        )
    }
    
    init(label: String, pressedKey: PressedKey, action: @escaping () -> Void) {
        self.label = label
        self.action = action
        self.pressedKey = pressedKey
        self.createPublisher()
    }
    
    init(label: String, pressedKey: PressedKey, width: CGFloat, action: @escaping () -> Void) {
        self.label = label
        self.action = action
        self.width = width
        self.pressedKey = pressedKey
        self.createPublisher()
    }
    
    init(label: String, pressedKey: PressedKey, bgColor: Color, fgColor: Color, action: @escaping () -> Void) {
        self.label = label
        self.action = action
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.pressedKey = pressedKey
        self.createPublisher()
    }
    
    func createPublisher() {
        if self.pressedKey.character == self.label {
            self.action()
            self.observedOpacity.value = 0.75
            print(self.label, "start", self.observedOpacity.value)
        }
    }
}
