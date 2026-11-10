//
//  Metal.h
//  ImageNoiseEditor
//
//  Created by Gabriel Thomson on 10/24/26.
//

#ifndef Noise_h
#define Noise_h

// Constants for Gold Noise
constant float PHI = 1.61803398874989484820459 * 0.0001; // Golden Ratio
constant float PI_FACTOR = 3.14159265358979323846264 * 0.0001; // PI
constant float SQ2 = 1.41421356237309504880169 * 10000.0; // Square Root of Two

// Gold Noise function: Returns a normalized pseudorandom float [0.0, 1.0]
float goldNoise(float2 coordinate, float seed) {
    return fract(tan(distance(coordinate * (seed + PHI), float2(PHI, PI_FACTOR))) * SQ2);
}

#endif /* Noise_h */
