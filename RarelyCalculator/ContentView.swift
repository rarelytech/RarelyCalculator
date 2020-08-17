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
    @ObservedObject var result: ObservedResult = ObservedResult()
    
    func inputEvent(_ event: NSEvent) {
        let code = event.keyCode
        let flag = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        
        var character = event.characters ?? ""
        
        switch flag {
        case [.option] where event.keyCode == kVK_ANSI_Minus,
             [.option, .numericPad] where event.keyCode == kVK_ANSI_KeypadMinus:
            character = "􀅺"
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
        
        switch character {
        case "+":
            character = "􀅼"
        case "-":
            character = "􀅽"
        case "*":
            character = "􀅾"
        case "/":
            character = "􀅿"
        case "\n":
            character = "􀆀"
        default:
            break
        }
        
        print(event.keyCode, character)
        self.pressedKey.character = character
    }
    
    func handleInput(_ key: String) {
        // self.result.current += key
        print("string ", key)
    }
    
    func handleInput(_ key: Int) {
        // self.result.current += String(key)
        print("int ", key)
    }
    
    var body: some View {
        let width:CGFloat = 344
        let height:CGFloat = 374
        
        // GeometryReader(content: { geometry in
        // .frame(width: 344, height: 354 - geometry.safeAreaInsets.top, alignment: .top)
        // })
        
        VStack (alignment: .center, spacing: 8) {
            // 暂存框
            Text("result.last")
                .fontWeight(.ultraLight)
                .frame(width: width - 44, height: 20, alignment: .trailing)
                .font(.system(size: 17))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 0, trailing: 18))
                .opacity(0.5)
            
            // 当前框 / 结果框
            Text(result.current != "" ? result.current : "0")
                .fontWeight(.light)
                .frame(width: width - 44, height: 44, alignment: .trailing)
                .font(.system(size: 48))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18))
                        
            HStack {
                ButtonView(label: "AC", pressedKey: self.pressedKey) {
                    print("click AC")
                }
                
                ButtonView(label: "􀅺", pressedKey: self.pressedKey) {
                    print("click 􀅺")
                }
                
                ButtonView(label: "􀘾", pressedKey: self.pressedKey) {
                    print("click 􀘾")
                }
                
                ButtonView(label: "􀅿", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀅿")
                }
            }
            
            HStack {
                ForEach (7..<10) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        // print("click \(n)")
                        handleInput(n)
                    }
                }
                
                ButtonView(label: "􀅾", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀅾")
                }
            }
            
            HStack {
                ForEach (4..<7) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        // print("click \(n)")
                        handleInput(n)
                    }
                }
                
                ButtonView(label: "􀅽", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀅽")
                }
            }
            
            HStack {
                ForEach (1..<4) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        // print("click \(n)")
                        handleInput(n)
                    }
                }
                
                ButtonView(label: "􀅼", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀅼")
                }
            }
            
            HStack {
                ButtonView(label: "0", pressedKey: self.pressedKey) {
                    // print("click 0")
                    handleInput(0)
                }
                
                ButtonView(label: ".", pressedKey: self.pressedKey) {
                    // print("click .")
                    handleInput(".")
                }
                
                ButtonView(label: "􀆀", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀆀")
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
