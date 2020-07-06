//
//  ViewController.swift
//  renamer 2.0
//
//  Created by Nortus on 7/5/20.
//  Copyright © 2020 Nortus. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var doneText: NSTextField!
    
    @IBAction func runButton(_ sender: NSButton) {
        var textToReplace: String = ""
        let path = DragView.filePath
        
        
        func check() -> Bool {
            print(path)
            if textField.stringValue != "" && path.path != "empty" {
                textToReplace = textField.stringValue
                return true
                
            }else{
                doneText.stringValue = "Enter the word to replace \n and choose folder first"
                doneText.textColor = NSColor.red
                doneText.sizeToFit()
                return false
            }
        }
        
        func rename(file: URL) {
            let newName = file.lastPathComponent.replacingOccurrences(of: textToReplace, with: "")
            let newFile = file.deletingLastPathComponent().appendingPathComponent(newName)
            do{
               try FileManager.default.moveItem(at: file, to: newFile)
            }catch {
                print("Error 2")
            }
        }
        
        func renamer(folder: URL) {
            do {
                let listFiles = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                var isDir: ObjCBool = false
                for i in listFiles{
                    if FileManager.default.fileExists(atPath: i.path, isDirectory: &isDir){
                        if isDir.boolValue {
                            renamer(folder: i)
                            rename(file: i)
                            
                        }else{
                            rename(file: i)
                        }
                    }
                }
            }catch {
                print("Error")
            }
        }
        
        if check() {
            renamer(folder: path)
            doneText.stringValue = "DONE"
            doneText.textColor = NSColor.green
        }
    }
    
    override func viewDidLoad() {
        
    }
}

