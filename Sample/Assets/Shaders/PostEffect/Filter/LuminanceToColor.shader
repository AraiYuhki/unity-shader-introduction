// 輝度取得シェーダー
Shader "Sample/PostEffect/LuminanceToColor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Param ("Param", Vector) = (0, 0, 0.2, 0.01)
        _DarkColor ("DarkColor", Color) = (0, 0, 0, 0)
        _LightColor ("LightColor", Color) = (1, 1, 1, 0)
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
            float4 _Param;
            float4 _DarkColor;
            float4 _LightColor;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 uv = (i.uv * 2.0 - 1.0) * float2(_MainTex_TexelSize.z * _MainTex_TexelSize.y, 1.0);
                fixed4 col = tex2D(_MainTex, i.uv);
                float luminance = Luminance(col.rgb);
                float radius = sin(_Time.y) * 0.5 + 0.5;
                float value = 1 - smoothstep(radius, radius + _Param.w, distance(uv, _Param.xy));
                col.rgb = lerp(col.rgb, lerp(_DarkColor.rgb, _LightColor.rgb, luminance), value);
                return col;
            }
            ENDCG
        }
    }
}
