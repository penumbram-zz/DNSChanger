//
//  EventMonitor.swift
//  DNSChanger
//
//  Created by Tolga Caner on 05/04/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Cocoa


public class EventMonitor {
    private var monitors: [AnyObject]
    private let masks: [NSEventMask]
    private let handler: (NSEvent?) -> ()
    
    public init(masks: [NSEventMask], handler: @escaping (NSEvent?) -> ()) {
        self.masks = masks
        self.handler = handler
        self.monitors = []
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        masks.map { elem in
            monitors.append(NSEvent.addGlobalMonitorForEvents(matching: elem, handler: handler) as AnyObject!)
        }
    }
    
    public func stop() {
        monitors.map { elem in
            NSEvent.removeMonitor(elem)
        }
        monitors.removeAll()
    }
}
