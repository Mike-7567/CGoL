//
//  MetalConstants.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import Metal

let DEVICE = MTLCreateSystemDefaultDevice()!
let COMMAND_QUEUE = DEVICE.makeCommandQueue()!
let LIBRARY = DEVICE.makeDefaultLibrary()!
let MAIN_COLOR_FORMAT = MTLPixelFormat.bgra8Unorm
