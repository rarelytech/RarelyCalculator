//
//  MainWindow.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/16.
//

import SwiftUI

class MainWindow: NSWindow {
    var isShow: Bool = false
    var cv = ContentView()
    
    override func keyDown(with event: NSEvent) {
        // Pass all key events to the project model
        // print(event.characters ?? "")
    }
    
    override func keyUp(with event: NSEvent) {
        // print(event.characters ?? "")
        let c = event.characters ?? ""
        self.cv.receiveKey(c)
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.isReleasedWhenClosed = false
        self.setFrameAutosaveName("Rarely Calculator")
        self.contentView = NSHostingView(rootView: cv.edgesIgnoringSafeArea(.top))
        self.makeKeyAndOrderFront(nil)
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.toolbar = nil
        self.level = .statusBar
        self.isOpaque = false
        self.backgroundColor = NSColor(red: 0, green: 0, blue: 0.5, alpha: 0)
        self.appearance = NSAppearance(named: .darkAqua)
        self.styleMask.remove(.titled)
        self.isMovable = false
        
        NSApplication.shared.hide(self)
        // self.show()
    }
    
    func hide(_ sender: NSStatusBarButton) {
        NSApplication.shared.hide(self)
        self.isShow = false
    }
    
    func show(_ sender: NSStatusBarButton) {
        let rect = sender.window?.frame ?? .zero
        let x = rect.origin.x - (self.frame.size.width - sender.bounds.width) / 2
        let y = rect.origin.y - self.frame.size.height - 1
        self.setFrameOrigin(CGPoint(x: x, y: y))
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        self.isShow = true
    }
    
    func toggleVisible(_ sender: NSStatusBarButton) {
        if self.isShow {
            self.hide(sender)
        } else {
            self.show(sender)
        }
    }
    
}
