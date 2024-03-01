//=================================================================================================
//
//  MJP's DX12 Sample Framework
//  http://mynameismjp.wordpress.com/
//
//  All code licensed under the MIT license
//
//=================================================================================================

#ifndef RAYTRACING_HLSL_
#define RAYTRACING_HLSL_

struct MeshVertex
{
    float3 Position;
    float3 Normal;
    float2 UV;
    float3 Tangent;
    float3 Bitangent;
};

float BarycentricLerp(in float v0, in float v1, in float v2, in float3 barycentrics)
{
    return v0 * barycentrics.x + v1 * barycentrics.y + v2 * barycentrics.z;
}

float2 BarycentricLerp(in float2 v0, in float2 v1, in float2 v2, in float3 barycentrics)
{
    return v0 * barycentrics.x + v1 * barycentrics.y + v2 * barycentrics.z;
}

float3 BarycentricLerp(in float3 v0, in float3 v1, in float3 v2, in float3 barycentrics)
{
    return v0 * barycentrics.x + v1 * barycentrics.y + v2 * barycentrics.z;
}

float4 BarycentricLerp(in float4 v0, in float4 v1, in float4 v2, in float3 barycentrics)
{
    return v0 * barycentrics.x + v1 * barycentrics.y + v2 * barycentrics.z;
}

MeshVertex BarycentricLerp(in MeshVertex v0, in MeshVertex v1, in MeshVertex v2, in float3 barycentrics)
{
    MeshVertex vtx;
    vtx.Position = BarycentricLerp(v0.Position, v1.Position, v2.Position, barycentrics);
    vtx.Normal = normalize(BarycentricLerp(v0.Normal, v1.Normal, v2.Normal, barycentrics));
    vtx.UV = BarycentricLerp(v0.UV, v1.UV, v2.UV, barycentrics);
    vtx.Tangent = normalize(BarycentricLerp(v0.Tangent, v1.Tangent, v2.Tangent, barycentrics));
    vtx.Bitangent = normalize(BarycentricLerp(v0.Bitangent, v1.Bitangent, v2.Bitangent, barycentrics));

    return vtx;
}

float AbsCosTheta(float3 w) { return abs(w.z); }

float Cos2Theta(float3 w) { return w.z * w.z; }

float Sin2Theta(float3 w) {
    return max((float)0, (float)1 - Cos2Theta(w));
}

float SinTheta(float3 w) {
    return sqrt(Sin2Theta(w));
}

float CosPhi(float3 w) {
    float sinTheta = SinTheta(w);
    return (sinTheta == 0) ? 1 : clamp(w.x / sinTheta, -1, 1);
}

float Cos2Phi(float3 w) {
    return CosPhi(w) * CosPhi(w);
}

float SinPhi(float3 w) {
    float sinTheta = SinTheta(w);
    return (sinTheta == 0) ? 0 : clamp(w.y / sinTheta, -1, 1);
}

float Sin2Phi(float3 w) {
    return SinPhi(w) * SinPhi(w);
}

float AbsDot(float3 v1, float3 v2) {
    return abs(dot(v1, v2));
}

float Tan2Theta(float3 w) {
    return Sin2Theta(w) / Cos2Theta(w);
}

bool SameHemisphere(float3 w, float3 wp) {
    return w.z * wp.z > 0;
}

#endif // RAYTRACING_HLSL_