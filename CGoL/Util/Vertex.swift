//
//  Vertex.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//


//
//  Vertex.swift
//  MetalSimulations
//
//  Created by Gabriel Thomson on 11/28/24.
//

import MetalKit

@MainActor
struct Vertex {
    var position: SIMD3<Float>
    var texcoords: SIMD2<Float>
    
    static let quadVertices: [Vertex] = [
        Vertex(position: simd_float3(1, 1, 1), texcoords: simd_float2(1, 1)),
        Vertex(position: simd_float3(1, -1, 1), texcoords: simd_float2(1, 0)),
        Vertex(position: simd_float3(-1, 1, 1), texcoords: simd_float2(0, 1)),
        Vertex(position: simd_float3(-1, -1, 1), texcoords: simd_float2(0, 0))
    ]
    
    static func buildDefaultVertexDescriptor() -> MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        
        descriptor.attributes[Int(PositionIndex.rawValue)].format = .float3
        descriptor.attributes[Int(PositionIndex.rawValue)].bufferIndex = 0
        descriptor.attributes[Int(PositionIndex.rawValue)].offset = 0
        
        descriptor.attributes[Int(TexCoordsIndex.rawValue)].format = .float2
        descriptor.attributes[Int(TexCoordsIndex.rawValue)].bufferIndex = 0
        descriptor.attributes[Int(TexCoordsIndex.rawValue)].offset = MemoryLayout<Vertex>.offset(of: \.texcoords)!
        
        descriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return descriptor
    }
}
