//
//  Renderer.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate, MouseTrackingDelegate {
    static private var frameCount: UInt32 = 0
    
    private var strokes: [(simd_float2, simd_float2)] = []
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
        
        guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            print("Failed to create compute encoder")
            return
        }
        computeEncoder.label = "Stroke and update kernel"
        
        if (!strokes.isEmpty) {
            let maxStrokes = 30
            let bottemBounds = max(0, strokes.count - maxStrokes)
            var i = strokes.count - 1
            while i >= bottemBounds {
                let stroke = strokes[i]
                computeEncoder.setComputePipelineState(ComputePiplines.stroke)
                computeEncoder.setTexture(Textures.data, index: DataTextureIndex.rawValue)
                computeEncoder.setSettings(settings)
                
                var strokeData = StrokeData(from: stroke.0, to: stroke.1)
                computeEncoder.setBytes(&strokeData, length: MemoryLayout<StrokeData>.stride, index: StrokeDataIndex.rawValue)
                computeEncoder.dispatchThreadgroups(MTLSize(width: Int(settings.dataTextureSize.x), height: Int(settings.dataTextureSize.y), depth: 1), threadsPerThreadgroup: .one)
                i -= 1
            }
            
            strokes = []
        }
        
        if (Renderer.frameCount % settings.updateRate == 0) {
            computeEncoder.setComputePipelineState(ComputePiplines.updateCells)
            computeEncoder.setTexture(Textures.data, index: DataTextureIndex.rawValue)
            computeEncoder.setTexture(Textures.tempOutput, index: TempOutputIndex.rawValue)
            computeEncoder.setSettings(settings)
            computeEncoder.dispatchThreadgroups(MTLSize(width: Int(settings.dataTextureSize.x), height: Int(settings.dataTextureSize.y), depth: 1), threadsPerThreadgroup: .one)
        }
        
        computeEncoder.endEncoding()
        
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
    
    func mouseDown(with event: NSEvent) {
        
    }
    
    func mouseDragged(with event: NSEvent) {
        guard let view = event.window?.contentView?.subviews[0].subviews[0] else {
            print("Could not get view")
            return
        }
        
        guard let mtkView = view as? MTKView else {
            print("View was not a MTKView: \(type(of: view))")
            return
        }
        
        guard let viewPoint = mtkView.convert(event.locationInWindow, from: nil) as CGPoint? else {
            print("Could not get start point")
            return
        }
        
        let from = texturePoint(from: viewPoint, texture: Textures.data, drawable: mtkView)
        let to = texturePoint(from: CGPoint(x: viewPoint.x + event.deltaX, y: viewPoint.y + event.deltaY), texture: Textures.data, drawable: mtkView)
        strokes.append((from, to))
        print("\(from), \(to)")
    }
    
    func mouseUp(with event: NSEvent) {
        
    }
    
    func mouseEntered(with event: NSEvent) {
        
    }
    
    func mouseExited(with event: NSEvent) {
        
    }
    
    func texturePoint(from viewPoint: CGPoint, texture: MTLTexture, drawable: MTKView) -> simd_float2 {
        let viewSize = drawable.drawableSize
        let texWidth  = Float(texture.width)
        let texHeight = Float(texture.height)

        let u = Float(viewPoint.x) / Float(viewSize.width) * 2
        let v = Float(viewPoint.y) / Float(viewSize.height) * 2
        
        return simd_float2(u * texWidth, v * texHeight)
    }
}
