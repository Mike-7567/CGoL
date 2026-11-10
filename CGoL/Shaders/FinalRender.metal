//
//  FinalRender.metal
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

#include <metal_stdlib>
using namespace metal;
#include "../Headers/Shared.h"

constexpr sampler samp = sampler(coord::normalized, filter::linear);

struct VertIn {
    float4 position [[attribute(PositionIndex)]];
    float2 texcoords [[attribute(TexCoordsIndex)]];
};

struct VertOut {
    float4 position [[position]];
    float2 texcoords;
};

vertex VertOut finalRenderVsh(VertIn in [[stage_in]]) {
    VertOut out;
    out.position = in.position;
    out.texcoords = in.texcoords;
    return out;
}

fragment float4 finalRenderFsh(VertOut vert [[stage_in]], texture2d<float, access::sample> tempOutput [[texture(DataTextureIndex)]]) {
    float amplifier = tempOutput.sample(samp, vert.texcoords).r;
    
    float3 color = float3(1.0 * vert.texcoords.x, 1.0 * vert.texcoords.y, 1.0 * (1.0 - vert.texcoords.y)) * amplifier;
    
    return float4(color, 1.);
}
