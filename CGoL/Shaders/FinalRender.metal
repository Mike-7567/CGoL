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
    float4 color;
    float2 texcoords;
};

vertex VertOut finalRenderVsh(VertIn in [[stage_in]]) {
    VertOut out;
    out.position = in.position;
    out.texcoords = in.texcoords;
    return out;
}

fragment float4 finalRenderFsh(VertOut vert [[stage_in]], texture2d<float, access::sample> tempOutput [[texture(DataTextureIndex)]]) {
    float3 color = tempOutput.sample(samp, vert.texcoords).rgb;
    
    return float4(color, 1.);
}
