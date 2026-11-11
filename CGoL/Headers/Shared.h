//
//  Shared.h
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

#ifndef Shared_h
#define Shared_h
#include "simd/simd.h"

struct SettingsStruct {
    simd_int2 dataTextureSize;
    uint8_t addCells;
    uint32_t updateRate;
    float strokeSize;
};

struct StrokeData {
    simd_float2 from;
    simd_float2 to;
};

enum TextureBufferIndicies {
    DataTextureIndex = 0,
    TempOutputIndex = 1
};

enum DataBufferIndicies {
    SettingsIndex = 1,
    StrokeDataIndex = 2
};

enum VertexAttributeIndicies {
    PositionIndex = 0,
    TexCoordsIndex = 1
};

#endif /* Shared_h */
