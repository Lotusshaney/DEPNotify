//
//  SheetViewController.swift
//  DEPNotify
//
//  Created by Federico Deis on 27/10/2017.
//  Copyright © 2018 AgileMobility360 LLC. All rights reserved.
//

import Foundation
import Cocoa
import SystemConfiguration
import SecurityFoundation


class RegisterViewController: NSViewController, NSTextFieldDelegate, NSApplicationDelegate {
    
    // Interface Builder Connectors
    @IBOutlet var registrationView: NSView!
    
    @IBOutlet weak var registerMainTitle: NSTextField!
    @IBOutlet weak var registerButton: NSButton!
    @IBOutlet weak var registerTitlePicture: NSImageView!
    
    @IBOutlet weak var UItextField1Required: NSImageView!
    @IBOutlet weak var UItextField2Required: NSImageView!
    
    @IBOutlet weak var UITextFieldUpper: NSTextField!
    @IBOutlet weak var UITextFieldLower: NSTextField!
    @IBOutlet weak var UIPopUpMenuUpper: NSPopUpButton!
    @IBOutlet weak var UIPopUpMenuLower: NSPopUpButton!

    @IBOutlet weak var UITextFieldUpperLabel: NSTextField!
    @IBOutlet weak var UITextFieldLowerLabel: NSTextField!
    @IBOutlet weak var UIPopUpMenuUpperLabel: NSTextField!
    @IBOutlet weak var UIPopUpMenuLowerLabel: NSTextField!
    
    @IBOutlet weak var registeringYourMacLabel: NSTextField!
    @IBOutlet weak var registeringYourMacIndicator: NSProgressIndicator!
    
    @IBOutlet weak var sensitiveInformation: NSButton!
    
    @IBOutlet weak var separator: NSBox!
    
    
    
    // Set Alert String Color
    let alertColor = NSColor(red:1,green:0,blue:0,alpha:1)
    //var registerButtonTitle = "Register"
    
    // Programatically creating a text field test
    
    // Set text field
    //let myTextField = NSTextField(frame: NSMakeRect(222,218,210,22))
    //myTextField.textColor = NSColor.red
    //myTextField.stringValue = "Hello World !!!"
    
    // Adding items to Pop Up Menu item
    //let myPopUpButton = NSPopUpButton(frame: NSMakeRect(222,180,210,22))
    //myPopUpButton.addItems(withTitles: ["Pais", "London", "Munich"])
    
    // Displaying input fields in NSVIew
    //view.addSubview(myTextField)
    
    //view.addSubview(myPopUpButton)
    
    
    // Some variables
    var upperPopUpMenu: [String]!
    var lowerPopUpMenu: [String]!
    var labelHeights = 0
    var PathToPlistDefault = "/Users/Shared/DEPNotify.plist"
    var plistPath = ""
    var registrationImage: NSImage?
    var UIPopUpMenuLowerValue = ""
    var UIPopUpMenuUpperValue = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Programmatically resizing NSView
        //registerWindow.frame = NSRect(x: 0, y: 0, width: 520, height: 320)
        //registerWindow.translatesAutoresizingMaskIntoConstraints = true
        //registerWindow.display()
        
        // Set window background color to white
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = CGColor.white

        // Set text field
        //let UITextFieldUpper = NSTextField(frame: NSMakeRect(222,218,210,22))
        //registrationView.addSubview(UITextFieldUpper)

//        let TextFieldUpperIsSecure = UserDefaults.standard.bool(forKey: "UITextFieldUpperIsSecure")
//        print ("Text Field Is Secure = \(TextFieldUpperIsSecure)")
//        if TextFieldUpperIsSecure {
//            UITextFieldUpperSecure.echosBullets = true
//        }
        
        // Set labels, buttons and view interface items from Preferences file
        if let registerTitlePicturePath = UserDefaults.standard.string(forKey: "RegisterTitlePicturePath") {
            registrationImage = NSImage.init(byReferencingFile: registerTitlePicturePath)
            
            registerTitlePicture.image = registrationImage
            registerTitlePicture.imageScaling = .scaleProportionallyUpOrDown
            registerTitlePicture.imageAlignment = .alignCenter
        } else {
            print ("No Title Picture Path file")
        }
        
        if let UITextFieldUpperToolTip = UserDefaults.standard.string(forKey: "UITextFieldUpperToolTip") {
            print ("Tool Tip: \(UITextFieldUpperToolTip)")
            UITextFieldUpper.toolTip = UITextFieldUpperToolTip
        }
        
        if let UITextFieldLowerToolTip = UserDefaults.standard.string(forKey: "UITextFieldLowerToolTip") {
            print ("Tool Tip: \(UITextFieldLowerToolTip)")
            UITextFieldLower.toolTip = UITextFieldLowerToolTip
        }
        
        if let UIPopUpUpperToolTip = UserDefaults.standard.string(forKey: "UIPopUpUpperToolTip") {
            print ("Tool Tip: \(UIPopUpUpperToolTip)")
            UIPopUpMenuUpper.toolTip = UIPopUpUpperToolTip
        }
    
        if let UIPopUpLowerToolTip = UserDefaults.standard.string(forKey: "UIPopUpLowerToolTip") {
            print ("Tool Tip: \(UIPopUpLowerToolTip)")
            UIPopUpMenuLower.toolTip = UIPopUpLowerToolTip
        }
        
        if let upperPopUpMenu = UserDefaults.standard.array(forKey: "UIPopUpMenuUpper")  {
            UIPopUpMenuUpper.removeAllItems()
            UIPopUpMenuUpper.addItems(withTitles: upperPopUpMenu as! [String])
            UIPopUpMenuUpper.selectItem(at: 0)
        } else {
            print ("No UpperPopUpMenu Defaults")
            UIPopUpMenuUpper.removeAllItems()
        }
        
        if let lowerPopUpMenu = UserDefaults.standard.array(forKey: "UIPopUpMenuLower")  {
            UIPopUpMenuLower.removeAllItems()
            UIPopUpMenuLower.addItems(withTitles: lowerPopUpMenu as! [String])
            UIPopUpMenuLower.selectItem(at: 0)
        } else {
            print ("No LowerPopUpMenu Defaults")
            UIPopUpMenuLower.removeAllItems()
        }
        
        if let UITextFieldUpperLabelValue = UserDefaults.standard.string(forKey: "UITextFieldUpperLabel"){
            UITextFieldUpperLabel.stringValue = UITextFieldUpperLabelValue
        } else {

            UITextFieldUpperLabel.isHidden = true
            UITextFieldUpper.isHidden = true
            labelHeights = 30
        }
        
        if let UITextFieldLowerLabelValue = UserDefaults.standard.string(forKey: "UITextFieldLowerLabel"){
            UITextFieldLowerLabel.stringValue = UITextFieldLowerLabelValue
            UITextFieldLower.frame = CGRect(x: 222, y: (188 + labelHeights), width: 210, height: 22 )
            UITextFieldLowerLabel.frame = CGRect(x: 57, y: (191 + labelHeights), width: 154, height: 17 )
            UItextField2Required.frame = CGRect(x: 440, y: (192 + labelHeights), width: 15, height: 15 )
            separator.frame = CGRect(x: 80, y: (107 + labelHeights), width: 360, height: 5 )
        } else {

            UITextFieldLowerLabel.isHidden = true
            UITextFieldLower.isHidden = true
            labelHeights = labelHeights + 30
        }
        
        if let UIPopUpMenuUpperLabelValue = UserDefaults.standard.string(forKey: "UIPopUpMenuUpperLabel"){
            UIPopUpMenuUpperLabel.stringValue = UIPopUpMenuUpperLabelValue
            UIPopUpMenuUpper.frame = CGRect(x: 220, y: (155 + labelHeights), width: 215, height: 22 )
            UIPopUpMenuUpperLabel.frame = CGRect(x: 57, y: (160 + labelHeights), width: 154, height: 17 )
        } else {
            //UIPopUpMenuUpperLabel.stringValue = "Default Upper label"
            UIPopUpMenuUpperLabel.isHidden = true
            UIPopUpMenuUpper.isHidden = true
            labelHeights = labelHeights + 30
        }
    
        if let UIPopUpMenuLowerLabelValue = UserDefaults.standard.string(forKey: "UIPopUpMenuLowerLabel"){
            UIPopUpMenuLowerLabel.stringValue = UIPopUpMenuLowerLabelValue
            UIPopUpMenuLower.frame = CGRect(x: 220, y: (124 + labelHeights), width: 215, height: 22 )
            UIPopUpMenuLowerLabel.frame = CGRect(x: 57, y: (129 + labelHeights), width: 154, height: 17 )
        } else {
            //UIPopUpMenuLowerLabel.stringValue = "Default Lower label"
            UIPopUpMenuLowerLabel.isHidden = true
            UIPopUpMenuLower.isHidden = true
            labelHeights = labelHeights + 30
        }
        
        // Set separator position programmatically
        separator.frame = CGRect(x: 80, y: (107 + labelHeights), width: 360, height: 5 )
        
        let sensitiveInformationValue = UserDefaults.standard.bool(forKey: "checkForSensitiveInformation")
            print (sensitiveInformationValue)
            sensitiveInformation.isHidden = !sensitiveInformationValue
            sensitiveInformation.frame = CGRect(x: 159, y: (79 + labelHeights), width: 260, height: 18 )
        
        if let registerButtonTitle = UserDefaults.standard.string(forKey: "RegisterButtonLabel"){
            registerButton.title = registerButtonTitle
        } else {
            registerButton.title = "Register"
        }
        
        if let registerMainText = UserDefaults.standard.string(forKey: "RegisterMainTitle"){
            registerMainTitle.stringValue = registerMainText
        } else {
            registerMainTitle.stringValue = "Register this Mac"
        }
        
        if let upperTextFieldPlaceholder = UserDefaults.standard.string(forKey: "UITextFieldUpperPlaceholder"){
            UITextFieldUpper.placeholderString = upperTextFieldPlaceholder
        } else {
            UITextFieldUpper.placeholderString = ""
        }
        
        if let lowerTextFieldPlaceholder = UserDefaults.standard.string(forKey: "UITextFieldLowerPlaceholder"){
            UITextFieldLower.placeholderString = lowerTextFieldPlaceholder
        } else {
            UITextFieldLower.placeholderString = ""
        }
        
        
        // Hide red dot indicators
        UItextField1Required.isHidden = true
        UItextField2Required.isHidden = true
        
    }
    
    
    // Replace special characters from text fields & Constrains Characters
    override func controlTextDidChange(_ obj: Notification) {
        
        // Check DEPNotify defaults to get upper and lower input fields regex
        if let UITextFieldUpperRegex = UserDefaults.standard.string(forKey: "UITextFieldUpperRegex") {
            let upperCharacterSet: CharacterSet = CharacterSet(charactersIn: UITextFieldUpperRegex).inverted
            self.UITextFieldUpper.stringValue = (self.UITextFieldUpper.stringValue.components(separatedBy: upperCharacterSet) as NSArray).componentsJoined(by: "")
        } else {
            let upperCharacterSet: CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-_. ").inverted
            self.UITextFieldUpper.stringValue = (self.UITextFieldUpper.stringValue.components(separatedBy: upperCharacterSet) as NSArray).componentsJoined(by: "")
        }
        
        if let UITextFieldLowerRegex = UserDefaults.standard.string(forKey: "UITextFieldLowerRegex") {
            let lowerCharacterSet: CharacterSet = CharacterSet(charactersIn: UITextFieldLowerRegex).inverted
            self.UITextFieldLower.stringValue = (self.UITextFieldLower.stringValue.components(separatedBy: lowerCharacterSet) as NSArray).componentsJoined(by: "")
        } else {
            let lowerCharacterSet: CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-_. ").inverted
            self.UITextFieldLower.stringValue = (self.UITextFieldLower.stringValue.components(separatedBy: lowerCharacterSet) as NSArray).componentsJoined(by: "")
        }
        
        UItextField1Required.isHidden = true
        UItextField2Required.isHidden = true
    }

    // Get current system UUID to use with JSS API
    func getSystemUUID() -> String? {
        let dev = IOServiceMatching("IOPlatformExpertDevice")
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, dev)
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        let ser: CFTypeRef = serialNumberAsCFString!.takeUnretainedValue()
        if let result = ser as? String {
            return result
        }
        return nil
    }
    
    // Get current system Serial number to use with JSS API
    func getSystemSerial() -> String? {
        let dev = IOServiceMatching("IOPlatformExpertDevice")
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, dev)
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        let ser: CFTypeRef = serialNumberAsCFString!.takeUnretainedValue()
        if let result = ser as? String {
            return result
        }
        return nil
    }
    
    // Checks for Empty Text Fields, If Empty an Error Message Will be Displayed
    func checkFields() {
        
        // Set Field Required Indicator to Hidden
        UItextField1Required.isHidden = true
        UItextField2Required.isHidden = true
        
        // Check if Text Fields are mandatory
        let lowerTextFieldIsOptional = UserDefaults.standard.bool(forKey: "lowerTextFieldIsOptional")
        
        let upperTextFieldIsOptional = UserDefaults.standard.bool(forKey: "upperTextFieldIsOptional")
        
        
        // Get NSTextField Values as Strings
        let UITextFieldUpperValue = UITextFieldUpper.stringValue
        let UITextFieldLowerValue = UITextFieldLower.stringValue
        
        // Turn on mandatory fields indicator
        if UITextFieldUpperValue.isEmpty && !UITextFieldUpper.isHidden && !upperTextFieldIsOptional {
            do {
                UItextField1Required.isHidden = false
                print("Required Upper Field Missing")
            }
        } else if UITextFieldLowerValue.isEmpty && !UITextFieldLower.isHidden && !lowerTextFieldIsOptional {
                do {
                UItextField2Required.isHidden = false
                print("Required Lower Field Missing")
        }

    } else {
            registeringYourMacIndicator.isHidden = false
            registeringYourMacLabel.isHidden = false
            registeringYourMacIndicator.startAnimation(self)

            writePlistFile()

            registeringYourMacIndicator.stopAnimation(self)
            registeringYourMacIndicator.isHidden = true
            registeringYourMacLabel.isHidden = true
            
            // Write bom file and self close Registation window
            writeBomFile()
            self.view.window?.close()
            
            //startRegistrationProcess(completionHandler: myCompletionHandler)
           
            }
        
        }
    
    
    func writePlistFile() {
        // Get NSTextField Values as Strings
        let UITextFieldUpperValue = UITextFieldUpper.stringValue
        let UITextFieldLowerValue = UITextFieldLower.stringValue
        let UIPopUpMenuUpperValue = UIPopUpMenuUpper.title
        let UIPopUpMenuLowerValue = UIPopUpMenuLower.title
        let sensitiveInformationValue = sensitiveInformation.state
        let systemUUIDValue = getSystemUUID()
        let systemSerialValue = getSystemSerial()
        
        if let PathToPlistFileValue = UserDefaults.standard.string(forKey: "PathToPlistFile"){
            plistPath = "\(PathToPlistFileValue)DEPNotify.plist"
        } else if let PathToPlistFileValue = UserDefaults.standard.string(forKey: "pathToPlistFile") {
            plistPath = "\(PathToPlistFileValue)DEPNotify.plist"
            
        } else {
            plistPath = PathToPlistDefault
        }
        
        // Set timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let LastRegistrationDate = dateFormatter.string(from: Date())
        print (LastRegistrationDate)
        
        // Write the DEPNotify.plist file
        
        // Set Plist Domain Keys
        let UITextFieldUpperKey = UITextFieldUpperLabel.stringValue
        let UITextFieldLowerKey = UITextFieldLowerLabel.stringValue
        let UIPopUpMenuUpperKey = UIPopUpMenuUpperLabel.stringValue
        let UIPopUpMenuLowerKey = UIPopUpMenuLowerLabel.stringValue

        // Check if Plist file exits
        if FileManager.default.fileExists(atPath: plistPath) {
            let plistContent = NSMutableDictionary(contentsOfFile: plistPath)!
            plistContent.setValue(UITextFieldUpperValue, forKey: UITextFieldUpperKey)
            plistContent.setValue(UITextFieldLowerValue, forKey: UITextFieldLowerKey)
            plistContent.setValue(UIPopUpMenuUpperValue, forKey: UIPopUpMenuUpperKey)
            plistContent.setValue(UIPopUpMenuLowerValue, forKey: UIPopUpMenuLowerKey)
            plistContent.setValue(sensitiveInformationValue, forKey: "Stores Sensitive Information")
            plistContent.setValue(systemSerialValue!, forKey: "Computer Serial")
            plistContent.setValue(systemUUIDValue!, forKey: "Computer UUID")
            plistContent.setValue(LastRegistrationDate, forKey: "Registration Date")
            
            plistContent.write(toFile: plistPath, atomically: true)
            print("Is Plist file created: Yes")
        }
        
        else {
        
        let dict : [String: Any] = [
            UITextFieldUpperKey: UITextFieldUpperValue,
            UITextFieldLowerKey: UITextFieldLowerValue,
            UIPopUpMenuUpperKey: UIPopUpMenuUpperValue,
            UIPopUpMenuLowerKey: UIPopUpMenuLowerValue,
            "Stores Sensitive Information": sensitiveInformationValue,
            "Computer Serial": systemSerialValue!,
            "Computer UUID": systemUUIDValue!,
            "Registration Date": LastRegistrationDate,
            
        ]
        let someData = NSDictionary(dictionary: dict)
        let isWritten = someData.write(toFile: plistPath, atomically: true)
        print("Is Plist file created: \(isWritten)")
        }
    }
    
    func writeBomFile() {
        let bomFile = "/var/tmp/com.depnotify.registration.done"
        // Create Registration complete bom file
        do {
            FileManager.default.createFile(atPath: bomFile, contents: nil, attributes: nil)
            print ("BOM file create")
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
  
            checkFields()

        //processStatusLabel.isHidden = false
        //registerButton.isEnabled = false

            //self.view.window?.close()
            //NSApp.terminate(nil)
        
        }
  
}
