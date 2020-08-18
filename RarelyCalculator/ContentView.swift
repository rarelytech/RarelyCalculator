//
//  ContentView.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/15.
//

import SwiftUI
import Carbon.HIToolbox

struct ContentView: View {
    
    @ObservedObject var pressedKey = ObservedKeyInput()
    @ObservedObject var observedInput: ObservedInput = ObservedInput()
        
    func inputEvent(_ event: NSEvent) {
        let characters: [String: Bool] = [
            "AC": false, "􀅺": false, "􀘾": false, "􀅿": false,
            "7": true, "8": true, "9": true, "􀅾": false,
            "4": true, "5": true, "6": true, "􀅽": false,
            "1": true, "2": true, "3": true, "􀅼": false,
            "0": true, ".": true, "􀆀": false
        ]
        
        let code = event.keyCode
        let flag = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        
        var character = event.characters ?? ""
        
        switch flag {
        case [.option] where event.keyCode == kVK_ANSI_Minus,
             [.option, .numericPad] where event.keyCode == kVK_ANSI_KeypadMinus:
            character = "􀅺"
            self.handleMinus()
            return
        case [.shift] where code == kVK_ANSI_Equal:
            character = "􀅼"
        default:
            break
        }
        
        switch code {
        case UInt16(kVK_Escape):
            character = "AC"
        case UInt16(kVK_ANSI_KeypadEnter), UInt16(kVK_Return):
            character = "􀆀"
        default:
            break
        }
        
        var symbol = ""
        switch character {
        case "+":
            symbol = character
            character = "􀅼"
        case "-":
            symbol = character
            character = "􀅽"
        case "*":
            symbol = character
            character = "􀅾"
        case "/":
            symbol = character
            character = "􀅿"
        case "\n":
            symbol = character
            character = "􀆀"
        default:
            break
        }
        
        guard let isInputNumber = characters[character] else { return }
        
        self.pressedKey.character = character
        
        if isInputNumber {
            self.handleInput(character)
        } else if symbol != "" {
            self.handleInput(symbol: symbol)
        } else if character == "􀆀" {
            self.handleEqual()
        } else if character == "AC" {
            self.handleClear()
        }
    }
    
    func handleInput(_ key: String) {
        if key == "." {
            if self.observedInput.entry.contains(".") {
                return
            }
        }
        self.observedInput.entry += key
    }
    
    func handleInput(_ key: Int) {
        self.handleInput(String(key))
    }
    
    func handleInput(symbol: String) {
        self.observedInput.store(symbol: symbol)
    }
    
    func handleEqual() {
        self.observedInput.equal()
    }
    
    func handleClear() {
        self.observedInput.clear()
    }
    
    func handleMinus() {
        self.observedInput.minus()
    }
    
    func handlePercentage() {
        self.observedInput.percentage()
    }
    
    // 算式
    var formula: String {
        get {
            var text = ""
            self.observedInput.storage.forEach { accumlator in
                text += " " + accumlator.value
            }
            return text
        }
    }
    
    var body: some View {
        let width:CGFloat = 344
        let height:CGFloat = 374
        
        // GeometryReader(content: { geometry in
        // .frame(width: 344, height: 354 - geometry.safeAreaInsets.top, alignment: .top)
        // })
        
        VStack (alignment: .center, spacing: 8) {
            // 暂存框
            Text(self.formula)
                .fontWeight(.ultraLight)
                .frame(width: width - 44, height: 20, alignment: .trailing)
                .font(.system(size: 17))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 0, trailing: 18))
                .opacity(0.5)
                .minimumScaleFactor(0.001)
                .lineLimit(1)
            
            // 当前框 / 结果框
            Text(self.observedInput.entryText())
                .fontWeight(.light)
                .frame(width: width - 44, height: 44, alignment: .trailing)
                .font(.system(size: 48))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18))
                .minimumScaleFactor(0.001)
                .lineLimit(1)
            
            HStack {
                ButtonView(label: self.observedInput.clearText(), pressedKey: self.pressedKey) {
                    self.handleClear()
                }
                
                ButtonView(label: "􀅺", pressedKey: self.pressedKey) {
                    self.handleMinus()
                }
                
                ButtonView(label: "􀘾", pressedKey: self.pressedKey) {
                    self.handlePercentage()
                }
                
                ButtonView(label: "􀅿", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    self.handleInput(symbol: "/")
                }
            }
            
            HStack {
                ForEach (7..<10) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        handleInput(n)
                    }
                }
                
                ButtonView(label: "􀅾", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    self.handleInput(symbol: "*")
                }
            }
            
            HStack {
                ForEach (4..<7) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        handleInput(n)
                    }
                }
                
                ButtonView(label: "􀅽", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    self.handleInput(symbol: "-")
                }
            }
            
            HStack {
                ForEach (1..<4) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        handleInput(n)
                    }
                }
                
                ButtonView(label: "􀅼", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    self.handleInput(symbol: "+")
                }
            }
            
            HStack {
                ButtonView(label: "0", pressedKey: self.pressedKey) {
                    handleInput(0)
                }
                
                ButtonView(label: ".", pressedKey: self.pressedKey) {
                    handleInput(".")
                }
                
                ButtonView(label: "􀆀", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    self.handleEqual()
                }
            }
        }
        .frame(width: width - 8, height: height - 8, alignment: .top)
        .padding(4)
        .background(Color.init(NSColor(red: 0, green: 0, blue: 0, alpha: 0.4)))
        .background(VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow))
        .cornerRadius(8.0, antialiased: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
