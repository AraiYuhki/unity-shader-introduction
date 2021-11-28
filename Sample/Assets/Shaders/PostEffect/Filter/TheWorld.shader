Shader "PostEffect/TheWorld"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _InnerRadius("InnerRadius", Float) = 0.2
        _OuterRadius("OuterRadius", Float) = 0.4
        _PolarInnerRadius("PolarInnerRadius", Float) = 0.2
        _PolarOuterRadius("PolarOuterRadius", Float) = 0.4
        _PolarAntialias("PolarAntialias", Float) = 0.4
        _Antialias ("Antialias", Float) = 0.02
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
            #include "../libs/Utility.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float _InnerRadius;
            float _OuterRadius;
            float _PolarInnerRadius;
            float _PolarOuterRadius;
            float _PolarAntialias;
            float _Antialias;

            float doughnutMask(float2 uv, float inner, float outer, float antialias)
            {
                float dist = distance(uv, float2(0, 0));
                float value = smoothstep(inner, inner + antialias, dist);
                value *= 1 - smoothstep(outer, outer + antialias, dist);
                return value;
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                float2 uv = (i.uv * 2.0 - 1.0) * float2(_MainTex_TexelSize.z * _MainTex_TexelSize.y, 1.0);
                float2 polarUV = ConvertPolarCordinate(i.uv, 0, 1.0, 0.75);
                float uvValue = doughnutMask(uv, _PolarInnerRadius, _PolarOuterRadius, _PolarAntialias);
                uvValue = min(uvValue, 0.5);
                fixed4 col = tex2D(_MainTex, lerp(i.uv, polarUV, uvValue));

                float colorValue = doughnutMask(uv, _InnerRadius, _OuterRadius, _Antialias);
                col.rgb = lerp(col.rgb, 1 - col.rgb, colorValue);
                return col;
            }
            ENDCG
        }
    }
}
