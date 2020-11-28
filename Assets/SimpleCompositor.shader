Shader "Hidden/SimpleCompositor"
{
    Properties
    {
        _ColorTex("", 2D) = "" {}
        _MatteTex("", 2D) = "" {}
    }

    CGINCLUDE

#include "UnityCG.cginc"

sampler2D _ColorTex;
sampler2D _MatteTex;
float _Depth;
float _Threshold;

void Vertex(uint vid : SV_VertexID,
            out float4 vertex : SV_Position,
            out float2 uv : TEXCOORD0)
{
    float x = (vid < 2 || vid == 3) ? 0 : 1;
    float y = vid & 1;

    float4 temp = mul(UNITY_MATRIX_P, float4(0, 0, -_Depth, 1));
    float d = temp.z / temp.w;

    vertex = float4(float2(x, y) * 2 - 1, d, 1);
    uv = float2(x, 1 - y);
}

float4 Fragment(float4 vertex : SV_Position,
                float2 uv : TEXCOORD0) : SV_Target
{
    float alpha = tex2D(_MatteTex, uv).r;
    clip(alpha - _Threshold);
    return float4(tex2D(_ColorTex, uv).rgb, alpha);
}

    ENDCG

    SubShader
    {
        Tags { "Queue" = "Overlay" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite On
            Cull off
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            ENDCG
        }
    }
}
