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
    
    let seenBorder: CGFloat = 2
    let noneBorder: CGFloat = 0
    let cornerRadius: CGFloat = 5
    
    func highlight() {
        self.layer?.borderColor = NSColor.controlAccentColor.cgColor
        self.layer?.cornerRadius = cornerRadius
        self.layer?.borderWidth = seenBorder
    }
    
    func unhighligh() {
        self.layer?.borderColor = NSColor.clear.cgColor
        self.layer?.borderWidth = noneBorder
    }
    
    func complete() {
        self.layer?.borderColor = NSColor.systemGreen.cgColor
        self.layer?.cornerRadius = cornerRadius
        self.layer?.borderWidth = seenBorder
    }
    
    func failToComplete() {
        self.layer?.borderColor = NSColor.systemRed.cgColor
        self.layer?.cornerRadius = cornerRadius
        self.layer?.borderWidth = seenBorder
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
            complete()
            return true
        }else {
            failToComplete()
            return false
        }
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        unhighligh()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        unhighligh()
    }
    
    
    
}
