//
//  ContentView.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/15.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pressedKey = PressedKey()
    
    func receiveKey(_ character: String) {
        print(character)
        self.pressedKey.character = character
    }
    
    var body: some View {
        let width:CGFloat = 344
        let height:CGFloat = 374
        
        // GeometryReader(content: { geometry in
        // .frame(width: 344, height: 354 - geometry.safeAreaInsets.top, alignment: .top)
        // })
        
        VStack (alignment: .center, spacing: 8) {
            // 绘制结果框
            Text("1400 ×")
                .fontWeight(.ultraLight)
                .frame(width: width - 44, height: 20, alignment: .trailing)
                .font(.system(size: 17))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 0, trailing: 18))
                .opacity(0.5)
            
            Text("0")
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
                        print("click \(n)")
                    }
                }
                
                ButtonView(label: "􀅾", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀅾")
                }
            }
            
            HStack {
                ForEach (4..<7) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        print("click \(n)")
                    }
                }
                
                ButtonView(label: "-", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀅽")
                }
            }
            
            HStack {
                ForEach (1..<4) {n in
                    ButtonView(label: String(n), pressedKey: self.pressedKey) {
                        print("click \(n)")
                    }
                }
                
                ButtonView(label: "􀅼", pressedKey: self.pressedKey, bgColor: Color(red: 1.0, green: 0.6, blue: 0.0), fgColor: .white) {
                    print("click 􀅼")
                }
            }
            
            HStack {
                ButtonView(label: "0", pressedKey: self.pressedKey, width: 160) {
                    print("click 0")
                }
                
                ButtonView(label: ".", pressedKey: self.pressedKey) {
                    print("click .")
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
