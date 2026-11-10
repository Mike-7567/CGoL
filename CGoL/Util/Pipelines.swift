//
//  Pipelines.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import Metal

class ComputePiplines {
    static private(set) var updateCells: MTLComputePipelineState!
    
    static func initialize() {
        let updateCellDescriptor = MTLComputePipelineDescriptor()
        updateCellDescriptor.computeFunction = LIBRARY.makeFunction(name: "updateCells")
        updateCellDescriptor.label = "Update cells pipeline state"
        updateCells = try! DEVICE.makeComputePipelineState(descriptor: updateCellDescriptor, options: []).0
    }
}

class RenderPipelines {
    static private(set) var final: MTLRenderPipelineState!
    
    static func initialize() {
        let finalDescriptor = MTLRenderPipelineDescriptor()
        finalDescriptor.vertexFunction = LIBRARY.makeFunction(name: "finalRenderVsh")
        finalDescriptor.fragmentFunction = LIBRARY.makeFunction(name: "finalRenderFsh")
        finalDescriptor.vertexDescriptor = Vertex.buildDefaultVertexDescriptor()
        finalDescriptor.colorAttachments[0].pixelFormat = MAIN_COLOR_FORMAT
        
        final = try! DEVICE.makeRenderPipelineState(descriptor: finalDescriptor)
    }
}
