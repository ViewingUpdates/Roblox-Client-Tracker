#version 150

struct Globals
{
    mat4 ViewProjection;
    vec4 ViewRight;
    vec4 ViewUp;
    vec4 ViewDir;
    vec3 CameraPosition;
    vec3 AmbientColor;
    vec3 SkyAmbient;
    vec3 Lamp0Color;
    vec3 Lamp0Dir;
    vec3 Lamp1Color;
    vec4 FogParams;
    vec4 FogColor_GlobalForceFieldTime;
    vec3 Exposure;
    vec4 LightConfig0;
    vec4 LightConfig1;
    vec4 LightConfig2;
    vec4 LightConfig3;
    vec4 ShadowMatrix0;
    vec4 ShadowMatrix1;
    vec4 ShadowMatrix2;
    vec4 RefractionBias_FadeDistance_GlowFactor_SpecMul;
    vec4 OutlineBrightness_ShadowInfo;
    vec4 CascadeSphere0;
    vec4 CascadeSphere1;
    vec4 CascadeSphere2;
    vec4 CascadeSphere3;
    float hybridLerpDist;
    float hybridLerpSlope;
    float evsmPosExp;
    float evsmNegExp;
    float globalShadow;
    float shadowBias;
    float shadowAlphaRef;
    float debugFlagsShadows;
};

struct TrailParams
{
    vec4 Params;
};

uniform vec4 CB0[31];
uniform vec4 CB1[1];
in vec4 POSITION;
in vec3 TEXCOORD0;
in vec4 TEXCOORD1;
out vec3 VARYING0;
out vec4 VARYING1;
out vec3 VARYING2;
out vec3 VARYING3;
out vec3 VARYING4;

void main()
{
    vec3 v0 = vec3(0.0);
    v0.x = TEXCOORD0.x;
    vec3 v1 = v0;
    v1.y = TEXCOORD0.y;
    vec3 v2 = v1;
    v2.z = 0.0;
    vec4 v3 = vec4(POSITION.xyz, 1.0);
    gl_Position = (POSITION + (CB0[6] * CB1[0].x)) * mat4(CB0[0], CB0[1], CB0[2], CB0[3]);
    VARYING0 = v2;
    VARYING1 = TEXCOORD1 * 0.0039215688593685626983642578125;
    VARYING2 = (POSITION.yxz * CB0[16].xyz) + CB0[17].xyz;
    VARYING3 = vec3(dot(CB0[20], v3), dot(CB0[21], v3), dot(CB0[22], v3));
    VARYING4 = CB0[7].xyz - POSITION.xyz;
}

