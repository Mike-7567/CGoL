//
//  Extensions.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import Metal

extension MTLComputeCommandEncoder {
    func setBytes(_ bytes: UnsafeRawPointer, length: Int, index: UInt32) {
        self.setBytes(bytes, length: length, index: Int(index))
    }
    
    func setSettings(_ settings: SettingsStruct) {
        var settings = settings
        self.setBytes(&settings, length: MemoryLayout<SettingsStruct>.stride, index: SettingsIndex.rawValue)
    }
    
    func setTexture(_ texture: MTLTexture, index: UInt32) {
        self.setTexture(texture, index: Int(index))
    }
}

extension MTLSize {
    static let one = MTLSize(width: 1, height: 1, depth: 1)
}

extension MTLRenderCommandEncoder {
    func setFragmentTexture(_ texture: MTLTexture, index: UInt32) {
        self.setFragmentTexture(texture, index: Int(index))
    }
}
