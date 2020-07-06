//
//  DragView.swift
//  renamer 2.0
//
//  Created by Nortus on 7/5/20.
//  Copyright © 2020 Nortus. All rights reserved.
//

import Foundation
import Cocoa


class DragView: NSView {
    static var filePath: URL = URL(string: "empty")!
    
    
    func highlight() {
        self.layer?.borderColor = NSColor.controlAccentColor.cgColor
        self.layer?.borderWidth = 2.0
    }
    
    func unhighligh() {
        self.layer?.borderColor = NSColor.clear.cgColor
        self.layer?.borderWidth = 0.0
    }
    
    func complete() {
        self.layer?.borderColor = NSColor.green.cgColor
        self.layer?.borderWidth = 2.0
    }
    
    override func awakeFromNib() {
        self.registerForDraggedTypes([.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let canReadPastBoardObjects = sender.draggingPasteboard.canReadObject(forClasses: [NSURL.self], options: nil)
        if canReadPastBoardObjects {
            highlight()
            return .copy
        }
        return NSDragOperation()
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        guard let file = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil), file.count == 1
            else{ return false }
        
        
        if let path = file[0] as? URL {
            DragView.filePath = path
        }
        
        var isDir: ObjCBool = false
        
        _ = FileManager.default.fileExists(atPath: DragView.filePath.path, isDirectory: &isDir)
        
        if isDir.boolValue {
            sender.draggingDestinationWindow?.orderFrontRegardless()
            return true
        }else {
            return false
        }
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        complete()
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        unhighligh()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        unhighligh()
    }
    
    
    
}
