Shader "Sample/Mask/Rect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Param ("Param", Vector) = (0.25, 0.25, 0.75, 0.75) // ç∂è„ÇÃç¿ïW âEâ∫ÇÃç¿ïW
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
            float4 _Param;
            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float2 uv = (i.uv * 2.0 - 1.0) * float2(_MainTex_TexelSize.z * _MainTex_TexelSize.y, 1.0);
                fixed4 col = tex2D(_MainTex, i.uv);
                float value = step(_Param.x, uv.x) * step(uv.x, _Param.z) * step(_Param.y, uv.y) * step(uv.y, _Param.w);
                col.rgb = lerp(fixed3(0, 0, 0), col.rgb, value);
                return col;
            }
            ENDCG
        }
    }
}
