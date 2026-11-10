//
//  UpdateKernel.metal
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

#include <metal_stdlib>
using namespace metal;
#include "../Headers/Shared.h"
#include "../Headers/Noise.h"

kernel void updateCells(uint2 uindex [[ thread_position_in_grid ]], texture2d<float, access::read> dataTexture [[ texture(DataTextureIndex) ]], texture2d<float, access::write> tempOutput [[ texture(TempOutputIndex) ]], constant SettingsStruct &settings [[ buffer(SettingsIndex) ]]) {
    if (settings.addCells == 1) {
        float2 pos = float2(uindex.x, uindex.y);
        float noise = round(goldNoise(pos, 1));
        tempOutput.write(noise, uindex);
        return;
    }
    int2 index = int2(uindex);
    int2 offsets[8] = {
        int2(1, 1),
        int2(-1, 1),
        int2(1, -1),
        int2(-1, -1),
        int2(1, 0),
        int2(-1, 0),
        int2(0, 1),
        int2(0, -1),
    };
    float livingNeighbors = 0;
    for (int i = 0; i < 8; i++) {
        int2 neighborPos = int2(index) + offsets[i];
        neighborPos.x = clamp(neighborPos.x, 0, settings.DataTextureSize.x);
        neighborPos.y = clamp(neighborPos.y, 0, settings.DataTextureSize.y);
        
        int diff = (neighborPos.x - index.x) + (neighborPos.y - index.x);
        if (diff != 0) {
            livingNeighbors += dataTexture.read(uint2(neighborPos)).r;
        }
    }
    
    if (livingNeighbors > 3 || livingNeighbors < 2) {
        tempOutput.write(0.0, uindex);
    }
    
    if (livingNeighbors == 3) {
        tempOutput.write(1.0, uindex);
    }
}
