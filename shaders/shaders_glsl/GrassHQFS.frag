#version 110

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
uniform vec4 CB0[52];
uniform sampler2D ShadowMapTexture;
uniform sampler3D LightMapTexture;
uniform sampler3D LightGridSkylightTexture;

varying vec4 VARYING0;
varying vec3 VARYING1;
varying vec3 VARYING2;
varying vec4 VARYING3;
varying vec3 VARYING5;

void main()
{
    float f0 = clamp(dot(step(CB0[19].xyz, abs(VARYING0.xyz - CB0[18].xyz)), vec3(1.0)), 0.0, 1.0);
    vec3 f1 = VARYING0.yzx - (VARYING0.yzx * f0);
    vec4 f2 = vec4(clamp(f0, 0.0, 1.0));
    vec4 f3 = mix(texture3D(LightMapTexture, f1), vec4(0.0), f2);
    vec4 f4 = mix(texture3D(LightGridSkylightTexture, f1), vec4(1.0), f2);
    vec4 f5 = texture2D(ShadowMapTexture, VARYING1.xy);
    float f6 = (1.0 - ((step(f5.x, VARYING1.z) * clamp(CB0[24].z + (CB0[24].w * abs(VARYING1.z - 0.5)), 0.0, 1.0)) * f5.y)) * f4.y;
    gl_FragData[0] = vec4(sqrt(clamp(mix(CB0[14].xyz, ((min((f3.xyz * (f3.w * 120.0)).xyz + (CB0[8].xyz + (CB0[9].xyz * f4.x)), vec3(CB0[16].w)) + (VARYING2 * f6)) * VARYING5) + ((((VARYING5 * clamp(VARYING3.z * pow(VARYING3.x, 3.0), 0.0, 1.0)) + vec3(pow(clamp(VARYING3.y, 0.0, 1.0), 12.0) * VARYING3.w)) * f6) * CB0[10].xyz), vec3(VARYING0.w)) * CB0[15].y, vec3(0.0), vec3(1.0))), 1.0);
}

//$$ShadowMapTexture=s1
//$$LightMapTexture=s6
//$$LightGridSkylightTexture=s7
