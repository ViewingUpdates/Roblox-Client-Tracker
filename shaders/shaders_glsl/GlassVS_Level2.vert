#version 110

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
uniform vec4 CB0[52];
uniform vec4 CB1[216];
attribute vec4 POSITION;
attribute vec4 NORMAL;
attribute vec2 TEXCOORD0;
attribute vec2 TEXCOORD1;
attribute vec4 COLOR0;
attribute vec4 COLOR1;
varying vec2 VARYING0;
varying vec2 VARYING1;
varying vec4 VARYING2;
varying vec4 VARYING3;
varying vec4 VARYING4;
varying vec4 VARYING5;
varying vec4 VARYING6;
varying vec4 VARYING7;
varying float VARYING8;

void main()
{
    vec3 v0 = (NORMAL.xyz * 0.0078740157186985015869140625) - vec3(1.0);
    int v1 = int(COLOR1.x) * 3;
    int v2 = v1 + 1;
    int v3 = v1 + 2;
    float v4 = dot(CB1[v1 * 1 + 0], POSITION);
    float v5 = dot(CB1[v2 * 1 + 0], POSITION);
    float v6 = dot(CB1[v3 * 1 + 0], POSITION);
    vec3 v7 = vec3(v4, v5, v6);
    float v8 = dot(CB1[v1 * 1 + 0].xyz, v0);
    float v9 = dot(CB1[v2 * 1 + 0].xyz, v0);
    float v10 = dot(CB1[v3 * 1 + 0].xyz, v0);
    vec3 v11 = vec3(v8, v9, v10);
    vec3 v12 = -CB0[11].xyz;
    float v13 = dot(v11, v12);
    vec3 v14 = CB0[7].xyz - v7;
    vec4 v15 = vec4(v4, v5, v6, 1.0);
    vec4 v16 = v15 * mat4(CB0[0], CB0[1], CB0[2], CB0[3]);
    vec3 v17 = ((v7 + (v11 * 6.0)).yxz * CB0[16].xyz) + CB0[17].xyz;
    vec4 v18 = vec4(v17.x, v17.y, v17.z, vec4(0.0).w);
    v18.w = 0.0;
    vec4 v19 = vec4(v14, v16.w);
    float v20 = COLOR0.w * 2.0;
    float v21 = clamp(v20 - 1.0, 0.0, 1.0);
    float v22 = (clamp(2.0 - (dot(v11, normalize(v19.xyz)) * 3.0), 0.0, 1.0) * 0.300000011920928955078125) * clamp(v20, 0.0, 1.0);
    vec4 v23 = COLOR0;
    v23.w = mix(v21, 1.0, v22);
    vec4 v24 = vec4(dot(CB0[20], v15), dot(CB0[21], v15), dot(CB0[22], v15), 0.0);
    v24.w = mix((COLOR1.w * 0.0039215688593685626983642578125) * v21, 1.0, v22);
    float v25 = COLOR1.y * 0.50359570980072021484375;
    float v26 = clamp(v13, 0.0, 1.0);
    vec3 v27 = (CB0[10].xyz * v26) + (CB0[12].xyz * clamp(-v13, 0.0, 1.0));
    vec4 v28 = vec4(v27.x, v27.y, v27.z, vec4(0.0).w);
    v28.w = (v26 * CB0[23].w) * (COLOR1.y * exp2((v25 * dot(v11, normalize(v12 + normalize(v14)))) - v25));
    gl_Position = v16;
    VARYING0 = TEXCOORD0;
    VARYING1 = TEXCOORD1;
    VARYING2 = v23;
    VARYING3 = v18;
    VARYING4 = v19;
    VARYING5 = vec4(v8, v9, v10, COLOR1.z);
    VARYING6 = v28;
    VARYING7 = v24;
    VARYING8 = NORMAL.w;
}

