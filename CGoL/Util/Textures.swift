//
//  Textures.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import Metal
import simd

class Textures {
    static private(set) var data: MTLTexture!
    static private(set) var tempOutput: MTLTexture!
    
    static func initialize(size: simd_int2) {
        let dataDescriptor = MTLTextureDescriptor()
        dataDescriptor.width = Int(size.x)
        dataDescriptor.height = Int(size.y)
        dataDescriptor.pixelFormat = MAIN_COLOR_FORMAT
        dataDescriptor.usage = [.shaderRead, .shaderWrite]
        dataDescriptor.storageMode = .shared
        
        data = DEVICE.makeTexture(descriptor: dataDescriptor)
        
        let tempOutputDescriptor = MTLTextureDescriptor()
        tempOutputDescriptor.width = Int(size.x)
        tempOutputDescriptor.height = Int(size.y)
        tempOutputDescriptor.pixelFormat = MAIN_COLOR_FORMAT
        tempOutputDescriptor.usage = [.shaderRead, .shaderWrite]
        tempOutputDescriptor.storageMode = .shared
        
        tempOutput = DEVICE.makeTexture(descriptor: tempOutputDescriptor)
    }
    
    static func resetTextures(size: simd_int2) {
        let dataDescriptor = MTLTextureDescriptor()
        dataDescriptor.width = Int(size.x)
        dataDescriptor.height = Int(size.y)
        dataDescriptor.pixelFormat = MAIN_COLOR_FORMAT
        dataDescriptor.usage = [.shaderRead, .shaderWrite]
        dataDescriptor.storageMode = .shared
        
        data = DEVICE.makeTexture(descriptor: dataDescriptor)
        
        let tempOutputDescriptor = MTLTextureDescriptor()
        tempOutputDescriptor.width = Int(size.x)
        tempOutputDescriptor.height = Int(size.y)
        tempOutputDescriptor.pixelFormat = MAIN_COLOR_FORMAT
        tempOutputDescriptor.usage = [.shaderRead, .shaderWrite]
        tempOutputDescriptor.storageMode = .shared
        
        tempOutput = DEVICE.makeTexture(descriptor: tempOutputDescriptor)
    }
}
