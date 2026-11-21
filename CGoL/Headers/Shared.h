//
//  Shared.h
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

#ifndef Shared_h
#define Shared_h
#include "simd/simd.h"

enum GameState {
    Running = 0,
    Paused = 1
};

struct SettingsStruct {
    simd_int2 dataTextureSize;
    enum GameState state;
    uint32_t updateRate;
    float strokeSize;
};

struct StrokeData {
    simd_float2 from;
    simd_float2 to;
    uint8_t rightClickMask;
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
