//
//  CPopover.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/16.
//

import SwiftUI

class MainPopover: NSPopover {
    
    override func keyUp(with event: NSEvent) {
        print(event.characters ?? "")
    }
    
    override func keyDown(with event: NSEvent) {
        // Pass all key events to the project model
        print(event.characters ?? "")
    }
    
    //    @objc func togglePopover2(_ sender: NSStatusBarButton) {
    //        if let button = self.statusBarItem.button {
    //            if self.isShown {
    //                self.performClose(sender)
    //            } else {
    //                self.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    //
    //                //                self.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    //                self.contentViewController?.view.window?.becomeKey()
    //                //                NSRunningApplication.current.activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
    //                //                NSApplication.shared.activate(ignoringOtherApps: true)
    //                //                NSApp.activate(ignoringOtherApps: true)
    //            }
    //        }
    //    }
}
