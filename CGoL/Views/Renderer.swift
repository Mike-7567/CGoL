//
//  Renderer.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate, InputDelegate {
    static private var frameCount: UInt32 = 0
    
    private var strokes: [StrokeData] = []
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
        
        strokes.append(StrokeData(from: .zero, to: .one, rightClickMask: 0))
        
        if (!strokes.isEmpty) {
            let maxStrokes = 40
            let bottemBounds = max(0, strokes.count - maxStrokes)
            var i = strokes.count - 1
            while i >= bottemBounds {
                let stroke = strokes[i]
                computeEncoder.setComputePipelineState(ComputePiplines.stroke)
                computeEncoder.setTexture(Textures.data, index: DataTextureIndex.rawValue)
                computeEncoder.setSettings(settings)
                
                var strokeData = stroke
                computeEncoder.setBytes(&strokeData, length: MemoryLayout<StrokeData>.stride, index: StrokeDataIndex.rawValue)
                computeEncoder.dispatchThreadgroups(MTLSize(width: Int(settings.dataTextureSize.x), height: Int(settings.dataTextureSize.y), depth: 1), threadsPerThreadgroup: .one)
                i -= 1
            }
            
            strokes = []
        }
        
        let updateFrame = settings.state == Running && Renderer.frameCount % settings.updateRate == 0
        
        if (updateFrame) {
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
        if (updateFrame) {
            blitEncoder.copy(from: Textures.tempOutput, to: Textures.data)
        } else {
            blitEncoder.copy(from: Textures.data, to: Textures.tempOutput)
        }
        
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
    
    #if os(macOS)
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
        
        let from = texturePoint(from: viewPoint, texture: Textures.data, drawable: mtkView, ios: false)
        let to = texturePoint(from: CGPoint(x: viewPoint.x + event.deltaX, y: viewPoint.y + event.deltaY), texture: Textures.data, drawable: mtkView, ios: false)
        let isRightClick: UInt8 = event.type == NSEvent.EventType.rightMouseDown ? 0 : 1
        strokes.append(StrokeData(from: from, to: to, rightClickMask: isRightClick))
    }
    
    func mouseUp(with event: NSEvent) {
        
    }
    
    func mouseEntered(with event: NSEvent) {
        
    }
    
    func mouseExited(with event: NSEvent) {
        
    }
    
    func keyUp(with event: NSEvent) {
        
    }
    
    func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 49:
            if (settings.state == Running) {
                settings.state = Paused
            } else {
                settings.state = Running
            }
        case 125:
            settings.updateRate += 1
        case 126:
            if (settings.updateRate > 1) {
                settings.updateRate -= 1
            }
        default:
            return
        }
    }
    #elseif os(iOS)
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count > 1) {
            return
        }
            
        let touch = touches.first
        
        guard let mtkView = touch?.view as? MTKView else {
            print("View was not a MTKView: \(type(of: touch?.view))")
            return
        }
        
        guard var toLocation = touch?.location(in: mtkView) else {
            print("Could not get current location")
            return
        }
        
        toLocation = toLocation * mtkView.contentScaleFactor
        
        guard var prevLocation = touch?.previousLocation(in: mtkView) else {
            print("Could not get previous location")
            return
        }
        
        prevLocation = prevLocation * mtkView.contentScaleFactor
        
        guard let currentPoint = mtkView.convert(toLocation, from: nil) as CGPoint? else {
            print("Could not get start point")
            return
        }
        
        guard let prevPoint = mtkView.convert(prevLocation, from: nil) as CGPoint? else {
            print("Could not get end point")
            return
        }
        
        let from = texturePoint(from: currentPoint, texture: Textures.data, drawable: mtkView, ios: true)
        let to = texturePoint(from: prevPoint, texture: Textures.data, drawable: mtkView, ios: true)
        strokes.append(StrokeData(from: from, to: to, rightClickMask: 0))
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    #endif
    
    func texturePoint(from viewPoint: CGPoint, texture: MTLTexture, drawable: MTKView, ios: Bool) -> simd_float2 {
        let viewSize = drawable.drawableSize
        let texWidth  = Float(texture.width)
        let texHeight = Float(texture.height)

        if (ios) {
            let u = Float(viewPoint.x) / Float(viewSize.width)
            let v = (1.0 - Float(viewPoint.y) / Float(viewSize.height))
            
            return simd_float2(u * texWidth, v * texHeight)
        } else {
            let u = Float(viewPoint.x) / Float(viewSize.width) * 2
            let v = Float(viewPoint.y) / Float(viewSize.height) * 2
            
            return simd_float2(u * texWidth, v * texHeight)
        }
    }
}
