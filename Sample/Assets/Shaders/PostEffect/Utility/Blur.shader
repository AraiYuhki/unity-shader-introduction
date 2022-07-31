Shader "Sample/PostEffect/Blur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurSize ("BlurSize", Float) = 2.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            uniform half _BlurSize;
            static const int BlurSampleCount = 8;
            static const float BlurColorAverage = 0.125; // 1/8
            // 円周上八ヵ所のオフセットをあらかじめ計算しておく
            static const float2 BlurKernel[BlurSampleCount] = {
                float2(-1.0, -1.0),
                float2(-1.0, 1.0),
                float2(1.0, -1.0),
                float2(1.0, 1.0),
                float2(-0.70711, 0),
                float2(0, 0.7011),
                float2(0.70711, 0),
                float2(0, -0.70711)
            };

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 scale = _BlurSize * 0.001;
                scale.y *= _MainTex_TexelSize.z * _MainTex_TexelSize.y;
                fixed4 color = 0;
                // ぼかし処理
                for (int j = 0; j < BlurSampleCount; j++) {
                    color += tex2D(_MainTex, i.uv + BlurKernel[j] * scale);
                }
                // 8の逆数をかけて平均を出す
                color.rgb *= BlurColorAverage;
                color.a = tex2D(_MainTex, i.uv).a;
                return color;
            }
            ENDCG
        }
    }
}
