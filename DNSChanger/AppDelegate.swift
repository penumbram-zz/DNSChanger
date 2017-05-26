//
//  AppDelegate.swift
//  DNSChanger
//
//  Created by Tolga Caner on 13/03/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var windowController : NSWindowController!
    var eventMonitor: EventMonitor?
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyboard = NSStoryboard.init(name: "Main", bundle: nil)
        windowController = storyboard.instantiateController(withIdentifier: "windowController") as! NSWindowController
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(AppDelegate.togglePopover(sender:))
        }
        
        popover.contentViewController = storyboard.instantiateController(withIdentifier: "popOverViewController") as? ViewController
        
        let eventBlock : (NSEvent?) -> Void = { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        };
        eventMonitor = EventMonitor(masks: [.leftMouseDown, .rightMouseDown], handler: eventBlock)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    
    applicatinisinstart
    
    
    
}

