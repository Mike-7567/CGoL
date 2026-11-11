//
//  SDFs.h
//  CGoL
//
//  Created by Gabriel Thomson on 11/10/26.
//

#ifndef SDFs_h
#define SDFs_h

float sdSegment(float2 p, float2 a, float2 b) {
    float2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

#endif /* SDFs_h */
