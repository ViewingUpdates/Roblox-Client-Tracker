#version 110

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
#include <SAParams.h>
uniform vec4 CB0[52];
uniform vec4 CB3[1];
uniform sampler2D ShadowMapTexture;
uniform sampler3D LightMapTexture;
uniform sampler3D LightGridSkylightTexture;
uniform sampler2D DiffuseMapTexture;
uniform sampler2D NormalMapTexture;
uniform sampler2D SpecularMapTexture;

varying vec2 VARYING0;
varying vec4 VARYING2;
varying vec4 VARYING3;
varying vec4 VARYING4;
varying vec4 VARYING5;
varying vec4 VARYING6;
varying vec4 VARYING7;

void main()
{
    float f0 = clamp(1.0 - (VARYING4.w * CB0[23].y), 0.0, 1.0);
    vec4 f1 = texture2D(DiffuseMapTexture, VARYING0);
    float f2 = f1.w;
    vec4 f3 = vec4(mix(VARYING2.xyz, f1.xyz, vec3(f2)), VARYING2.w);
    vec4 f4 = vec4(f1.xyz, VARYING2.w * f2);
    bvec4 f5 = bvec4(CB3[0].x != 0.0);
    vec4 f6 = vec4(f5.x ? f3.x : f4.x, f5.y ? f3.y : f4.y, f5.z ? f3.z : f4.z, f5.w ? f3.w : f4.w);
    vec2 f7 = texture2D(NormalMapTexture, VARYING0).wy * 2.0;
    vec2 f8 = f7 - vec2(1.0);
    float f9 = sqrt(clamp(1.0 + dot(vec2(1.0) - f7, f8), 0.0, 1.0));
    vec2 f10 = vec3(f8, f9).xy * f0;
    vec4 f11 = texture2D(SpecularMapTexture, VARYING0);
    vec3 f12 = normalize(((VARYING6.xyz * f10.x) + ((cross(VARYING5.xyz, VARYING6.xyz) * VARYING6.w) * f10.y)) + (VARYING5.xyz * f9));
    vec3 f13 = f6.xyz;
    vec3 f14 = VARYING7.xyz - (CB0[11].xyz * VARYING3.w);
    float f15 = clamp(dot(step(CB0[19].xyz, abs(VARYING3.xyz - CB0[18].xyz)), vec3(1.0)), 0.0, 1.0);
    vec3 f16 = VARYING3.yzx - (VARYING3.yzx * f15);
    vec4 f17 = vec4(clamp(f15, 0.0, 1.0));
    vec4 f18 = mix(texture3D(LightMapTexture, f16), vec4(0.0), f17);
    vec4 f19 = mix(texture3D(LightGridSkylightTexture, f16), vec4(1.0), f17);
    vec4 f20 = texture2D(ShadowMapTexture, f14.xy);
    float f21 = f14.z;
    float f22 = length(VARYING4.xyz);
    vec3 f23 = (f13 * f13).xyz;
    float f24 = CB0[26].w * f0;
    float f25 = max(f11.y, 0.04500000178813934326171875);
    float f26 = f11.x * f24;
    vec3 f27 = -CB0[11].xyz;
    vec3 f28 = normalize(f27 + (VARYING4.xyz / vec3(f22)));
    float f29 = clamp(dot(f12, f27) * ((1.0 - ((step(f20.x, f21) * clamp(CB0[24].z + (CB0[24].w * abs(f21 - 0.5)), 0.0, 1.0)) * f20.y)) * f19.y), 0.0, 1.0);
    float f30 = f25 * f25;
    float f31 = max(0.001000000047497451305389404296875, dot(f12, f28));
    float f32 = dot(f27, f28);
    float f33 = 1.0 - f32;
    float f34 = f33 * f33;
    float f35 = (f34 * f34) * f33;
    vec3 f36 = vec3(f35) + (mix(vec3(0.039999999105930328369140625), f23, vec3(f26)) * (1.0 - f35));
    float f37 = f30 * f30;
    float f38 = (((f31 * f37) - f31) * f31) + 1.0;
    float f39 = 1.0 - f26;
    vec3 f40 = (((((vec3(f39) - (f36 * (f24 * f39))) * CB0[10].xyz) * f29) + min((f18.xyz * (f18.w * 120.0)).xyz + (CB0[8].xyz + (CB0[9].xyz * f19.x)), vec3(CB0[16].w))) * f23) + ((f36 * (((f37 + (f37 * f37)) / (((f38 * f38) * ((f32 * 3.0) + 0.5)) * ((f31 * 0.75) + 0.25))) * f29)) * CB0[10].xyz);
    float f41 = f6.w;
    vec4 f42 = vec4(f40.x, f40.y, f40.z, vec4(0.0).w);
    f42.w = f41;
    vec3 f43 = sqrt(clamp(mix(CB0[14].xyz, f42.xyz, vec3(clamp(exp2((CB0[13].z * f22) + CB0[13].x) - CB0[13].w, 0.0, 1.0))).xyz * CB0[15].y, vec3(0.0), vec3(1.0))) + vec3((-0.00048828125) + (0.0009765625 * fract(52.98291778564453125 * fract(dot(gl_FragCoord.xy, vec2(0.067110560834407806396484375, 0.005837149918079376220703125))))));
    vec4 f44 = vec4(f43.x, f43.y, f43.z, f42.w);
    f44.w = f41;
    gl_FragData[0] = f44;
}

//$$ShadowMapTexture=s1
//$$LightMapTexture=s6
//$$LightGridSkylightTexture=s7
//$$DiffuseMapTexture=s3
//$$NormalMapTexture=s4
//$$SpecularMapTexture=s5
