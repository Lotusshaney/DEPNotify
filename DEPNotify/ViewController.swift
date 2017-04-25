//
//  ViewController.swift
//  DEPNotify
//
//  Created by Joel Rennich on 2/16/17.
//  Copyright © 2017 Trusource Labs. All rights reserved.
//

import Cocoa

private var statusContext = 0
private var commandContext = 1

class ViewController: NSViewController {
    @IBOutlet weak var MainText: NSTextField!
    @IBOutlet weak var ProgressBar: NSProgressIndicator!
    @IBOutlet weak var StatusText: NSTextField!
    @IBOutlet weak var LogoCell: NSImageCell!
    @IBOutlet var myView: NSView!
    @IBOutlet weak var helpButton: NSButton!

    var tracker = TrackProgress()

    var helpURL = String()

    var determinate = false
    var totalItems: Double = 0
    var currentItem = 0

    var notify = false

    var logo: NSImage?


    let myWorkQueue = DispatchQueue(label: "menu.nomad.DEPNotify.background_work_queue", attributes: [])

    override func viewDidLoad() {

        ProgressBar.startAnimation(nil)

        tracker.addObserver(self, forKeyPath: "statusText", options: .new, context: &statusContext)
        tracker.addObserver(self, forKeyPath: "command", options: .new, context: &commandContext)
        tracker.run()
        NSApp.windows[0].makeKeyAndOrderFront(self)

    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func updateStatus(status: String) {

        self.StatusText.stringValue = status
        print(self.StatusText.stringValue)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &statusContext {
            if let newValue = change?[.newKey] {
                print(newValue)
                print("Change observed")
                updateStatus(status: newValue as! String)
                if notify {
                    sendNotification(text: newValue as! String)
                }
                if determinate {
                    currentItem += 1
                    ProgressBar.increment(by: 1)
                }
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        } else if context == &commandContext {
            if let newValue = change?[.newKey] {
                print("Command observed")
                print(newValue)
                processCommand(command: newValue as! String)
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }

        }
    }

    func processCommand(command: String) {
        switch command.components(separatedBy: " ").first! {

        case "Alert:" :
            let alertController = NSAlert()
            alertController.messageText = command.replacingOccurrences(of: "Alert: ", with: "")
            alertController.addButton(withTitle: "Ok")
            alertController.beginSheetModal(for: NSApp.windows[0])

        case "Determinate:" :
            determinate = true
            ProgressBar.isIndeterminate = false

            // error check this
            totalItems = Double(command.replacingOccurrences(of: "Determinate: ", with: ""))!
            ProgressBar.maxValue = totalItems
            currentItem = 0
            ProgressBar.startAnimation(nil)

        case "Help:" :
            helpButton.isHidden = false
            helpURL = command.replacingOccurrences(of: "Help: ", with: "")

        case "Image:" :
            logo = NSImage.init(byReferencingFile: command.replacingOccurrences(of: "Image: ", with: ""))
            LogoCell.image = logo
            LogoCell.imageScaling = .scaleProportionallyUpOrDown
            LogoCell.imageAlignment = .alignCenter

        case "Logout:" :
            let alertController = NSAlert()
            alertController.messageText = command.replacingOccurrences(of: "Logout: ", with: "")
            alertController.addButton(withTitle: "Logout")
            //alertController.addButton(withTitle: "Quit")
            alertController.beginSheetModal(for: NSApp.windows[0]) { response in
                self.quitSession()
                NSApp.terminate(self)
            }

        case "MainText:" :
            // Need to do two replacingOccurrences since we are replacing with different values
            let newlinecommand = command.replacingOccurrences(of: "\\n", with: "\n")
            MainText.stringValue = newlinecommand.replacingOccurrences(of: "MainText: ", with: "")

        case "Notification:" :
            sendNotification(text: command.replacingOccurrences(of: "Notification: ", with: ""))

        case "NotificationOn:" :
            notify = true

        case "WindowStyle:" :
            switch command.replacingOccurrences(of: "WindowStyle: ", with: "") {
            case "NotMovable" :
                NSApp.windows[0].center()
                NSApp.windows[0].isMovable = false
            default :
                break
            }

        case "WindowTitle:" :
            let title = command.replacingOccurrences(of: "WindowTitle: ", with: "")
            NSApp.windows[0].title = title

        case "Quit" :
            NSApp.terminate(self)

        case "Quit:" :
            let alertController = NSAlert()
            alertController.messageText = command.replacingOccurrences(of: "Quit: ", with: "")
            alertController.addButton(withTitle: "Quit")
            alertController.beginSheetModal(for: NSApp.windows[0]) { response in
                NSApp.terminate(self)
            }

        default:
            break
        }
    }

    func quitSession() {
        var targetDesc: AEAddressDesc = AEAddressDesc.init()
        var psn = ProcessSerialNumber(highLongOfPSN: UInt32(0), lowLongOfPSN: UInt32(kSystemProcess))
        var eventReply: AppleEvent = AppleEvent(descriptorType: UInt32(typeNull), dataHandle: nil)
        var eventToSend: AppleEvent = AppleEvent(descriptorType: UInt32(typeNull), dataHandle: nil)

        var status: OSErr = AECreateDesc(
            UInt32(typeProcessSerialNumber),
            &psn,
            MemoryLayout<ProcessSerialNumber>.size,
            &targetDesc
        )

        status = AECreateAppleEvent(
            UInt32(kCoreEventClass),
            kAELogOut,
            &targetDesc,
            AEReturnID(kAutoGenerateReturnID),
            AETransactionID(kAnyTransactionID),
            &eventToSend
        )

        AEDisposeDesc(&targetDesc)

        let osstatus = AESendMessage(
            &eventToSend,
            &eventReply,
            AESendMode(kAENormalPriority),
            kAEDefaultTimeout
        )

    }

    func sendNotification(text: String) {
        let notification = NSUserNotification()

        if logo != nil {
            notification.contentImage = logo
        }

        notification.title = "Setup notification"
        notification.informativeText = text
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    @IBAction func HelpClick(_ sender: Any) {
        NSWorkspace.shared().open(URL(string: helpURL)!)
    }

}
