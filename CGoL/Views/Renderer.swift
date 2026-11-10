//
//  Renderer.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    static private var frameCount: UInt32 = 0
    
    var settings = DEFAULT_SETTINGS
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let currentDrawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        guard let commandBuffer = COMMAND_QUEUE.makeCommandBuffer() else {
            print("Failed to create command buffer")
            return
        }
        
        if (Renderer.frameCount % settings.updateRate == 0) {
            guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
                print("Failed to create compute encoder")
                return
            }
            computeEncoder.label = "Update kernel"
            computeEncoder.setComputePipelineState(ComputePiplines.updateCells)
            computeEncoder.setTexture(Textures.data, index: DataTextureIndex.rawValue)
            computeEncoder.setTexture(Textures.tempOutput, index: TempOutputIndex.rawValue)
            computeEncoder.setSettings(settings)
            computeEncoder.dispatchThreadgroups(MTLSize(width: Int(settings.DataTextureSize.x), height: Int(settings.DataTextureSize.y), depth: 1), threadsPerThreadgroup: .one)
            
            computeEncoder.endEncoding()
        }
        
        guard let blitEncoder = commandBuffer.makeBlitCommandEncoder() else {
            print("Failed to create blit encoder")
            return
        }
        blitEncoder.copy(from: Textures.tempOutput, to: Textures.data)
        
        blitEncoder.endEncoding()
        
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            print("Failed to create render encoder")
            return
        }
        renderEncoder.label = "Draw cells"
        renderEncoder.setRenderPipelineState(RenderPipelines.final)
        renderEncoder.setVertexBytes(Vertex.quadVertices, length: MemoryLayout<Vertex>.stride * 4, index: 0)
        renderEncoder.setFragmentTexture(Textures.data, index: DataTextureIndex.rawValue)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        renderEncoder.endEncoding()
        
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        Renderer.frameCount += 1
    }
}
