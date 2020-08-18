//
//  AppDelegate.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/15.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: MainWindow!
    var popover: MainPopover!
    var isHideWhenDeactive: Bool = true
    
    // 创建菜单
    let statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var hideWhenDeactiveMenu: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem.menu = nil
        statusMenu.delegate = self
        // 创建window
        asWindow()
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "StatusIcon")
            button.action = #selector(statusClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        if self.isHideWhenDeactive {
            self.window.hide(self.statusBarItem.button!)
        }
    }
    
    @IBAction func hideWhenDeactiveClick(_ sender: Any) {
        self.isHideWhenDeactive = !self.isHideWhenDeactive
        hideWhenDeactiveMenu.state = self.isHideWhenDeactive ? .on : .off
    }
    
    @IBAction func exitClick(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    func asWindow() {
        self.window = MainWindow(
            contentRect: NSRect(x: 0, y: 0, width: 344, height: 354),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
    }
    
    @objc func toggleWindow(_ sender: NSStatusBarButton) {
        self.window.toggleVisible(sender)
    }
    
    @objc func statusClick (_ sender: NSStatusBarButton) {
        if let event = NSApp.currentEvent {
            switch event.type {
            case .leftMouseUp:
                self.toggleWindow(sender)
            default:
                self.statusBarItem.menu = statusMenu
                self.statusBarItem.button?.performClick(nil)
            }
        }
    }
    
}

extension AppDelegate: NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        self.statusBarItem.menu = nil
    }
}
