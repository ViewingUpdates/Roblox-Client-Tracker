#version 110

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
#include <Params.h>
uniform vec4 CB0[52];
uniform vec4 CB1[8];
uniform sampler2D blurredTexture;
uniform sampler2D originalTexture;

varying vec2 VARYING0;

void main()
{
    vec4 f0 = vec4(2.0, 2.0, -2.0, 0.0) * CB1[0].zwzw;
    vec2 f1 = f0.xy;
    vec2 f2 = f0.wy;
    vec2 f3 = f0.zy;
    gl_FragData[0] = vec4(sqrt(clamp(((((((((((texture2D(blurredTexture, VARYING0 - f1) + (texture2D(blurredTexture, VARYING0 - f2) * 2.0)) + texture2D(blurredTexture, VARYING0 - f3)) + (texture2D(blurredTexture, VARYING0 + f0.zw) * 2.0)) + (texture2D(blurredTexture, VARYING0) * 4.0)) + (texture2D(blurredTexture, VARYING0 + f0.xw) * 2.0)) + texture2D(blurredTexture, VARYING0 + f3)) + (texture2D(blurredTexture, VARYING0 + f2) * 2.0)) + texture2D(blurredTexture, VARYING0 + f1)) * 0.0625).xyz * 1.0) * CB0[15].y, vec3(0.0), vec3(1.0))), texture2D(originalTexture, VARYING0).w);
}

//$$blurredTexture=s2
//$$originalTexture=s1
