//
//  StrokeKernel.metal
//  CGoL
//
//  Created by Gabriel Thomson on 11/10/26.
//

#include <metal_stdlib>
using namespace metal;
#include "../Headers/Shared.h"
#include "../Headers/SDFs.h"

kernel void addCellsFromStroke(uint2 uindex [[ thread_position_in_grid ]], texture2d<float, access::write> dataTexture [[ texture(DataTextureIndex) ]], constant SettingsStruct &settings [[ buffer(SettingsIndex) ]], constant StrokeData &strokeData [[ buffer(StrokeDataIndex) ]]) {
    
    float2 p = float2(uindex.x, uindex.y);
    
    float dis = sdSegment(p, strokeData.from, strokeData.to) - settings.strokeSize;
    
    if (dis <= 0) {
        dataTexture.write(1.0, uindex);
    }
}
