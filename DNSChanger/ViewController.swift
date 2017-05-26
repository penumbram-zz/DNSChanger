//
//  ViewController.swift
//  DNSChanger
//
//  Created by Tolga Caner on 13/03/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Cocoa
import Foundation
import ServiceManagement

enum DNSType : Int {
    case NoDNS
    case GoogleDNS
    case OpenDNS
}

let username = "" //your mac username
let password = "" //your mac password

class Run {
    var error: NSDictionary?
    
    func runAsRoot(cmd:String) -> NSObject? {
        let result = NSAppleScript(source: "do shell script \"sudo \(cmd)\" user name \"\(username)\" password \"\(password)\" with administrator privileges")!.executeAndReturnError(&error)
        if error != nil
        {
            return error
        }
        return result
    }
    
    func run(cmd:String) -> Any? {
        let desc = NSAppleScript(source: "do shell script \"\(cmd)\"s")!.executeAndReturnError(&error)
        if error != nil {
            return error
        }else {
            return desc.stringValue
        }
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var popUpButton: NSPopUpButton!

    let googleDNS = "8.8.8.8 8.8.4.4"
    let openDNS = "208.67.222.222 208.67.220.220"
    let noDNS = "Empty"
    let runner = Run()

    @IBAction func itemChanged(_ sender: NSPopUpButton) {
        let type = DNSType(rawValue:sender.indexOfSelectedItem)!
        var dnsString = ""
        switch type {
        case .NoDNS:
            dnsString = noDNS
            break
        case .GoogleDNS:
            dnsString = googleDNS
            break
        case .OpenDNS:
            dnsString = openDNS
            break
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {[weak self] in
            if self?.runner != nil {
                let result = self?.runner.runAsRoot(cmd: "networksetup -setdnsservers 'Wi-Fi' \(dnsString)")
                let result2 = ""//self?.runner.runAsRoot(cmd: "discoveryutil mdnsflushcache")
                self?.setActiveDNS()
                print("\(result) --- \(result2)"  )
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActiveDNS()
        // Do any additional setup after loading the view.
    }
    
    func setActiveDNS() {
        let result = runner.runAsRoot(cmd: "networksetup -getdnsservers 'Wi-Fi'")
        if let resultDesc = result as? NSAppleEventDescriptor {
            let resultString = resultDesc.stringValue!
            if resultString.contains(googleDNS.components(separatedBy: " ")[0]) {
                popUpButton.selectItem(at: 1)
            } else if (resultString.contains(openDNS.components(separatedBy: " ")[0])) {
                popUpButton.selectItem(at: 2)
            } else {
                popUpButton.selectItem(at: 0)
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func runTerminalCommand() {
        //let result = runner.runAsRoot(cmd: "networksetup -setdnsservers 'Wi-Fi' \(googleDNS)")
    }

}

