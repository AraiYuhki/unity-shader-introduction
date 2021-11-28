Shader "Unlit/Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 0.3)
        _LineScrollSpeed("LineScrollSpeed", Float) = 1.0
        _LineCount ("LineCount", Float) = 400.0
        _LineWidth ("LineWidth", Range(0.01, 1.0)) = 0.2
        _ScanScrollSpeed("ScanScrollSpeed", Float) = -1.0
    }
    SubShader
    {
        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        LOD 100

        Pass
        {
            Blend SrcAlpha One
            ZWrite Off
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "../PostEffect/libs/Utility.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LineScrollSpeed;
            float _ScanScrollSpeed;
            float _LineCount;
            float _LineWidth;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float uvOffset = spikeNoise(i.uv) * random(_Time.xy) * step(0.99, tan(_Time.y));
                fixed4 col = tex2D(_MainTex, i.uv + float2(uvOffset, 0.0));

                float scanLine = sin(_Time.y * _LineScrollSpeed + i.uv.y * _LineCount) * 0.5 + 0.5;
                scanLine = step(scanLine, _LineWidth) * 0.5;
                float scan = saturate(tan(_Time.y * _ScanScrollSpeed + i.uv.y * 2.0) - 0.5);

                float value = saturate(scanLine + scan);

                col.rgb *= _Color.rgb;
                col.rgb += value * _Color.rgb * _Color.a;
                col.rgb *= fixed3(random(i.uv + _Time.zy), random(i.uv + _Time.xy), random(i.uv + _Time.zw));

                return col;
            }
            ENDCG
        }
    }
}
