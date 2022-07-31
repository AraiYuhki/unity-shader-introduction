Shader "Sample/PostEffect/ColorCoordinate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Bright("Bright", Range(0, 10.0)) = 1.0 // 明度
        _Saturation("Saturation", Range(-10.0, 10.0)) = 1.0 // 彩度
        _Contrast("Contrast", Range(-1.0, 10.0)) = 1.0 // コントラスト
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
            float _Bright;
            float _Saturation;
            float _Contrast;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= _Bright;
                float luminance = Luminance(col.rgb);
                float3 intensity = fixed3(luminance, luminance, luminance);
                float3 satColor = lerp(intensity, col.rgb, _Saturation);
                col.rgb = lerp(float3(0.5, 0.5, 0.5), satColor, _Contrast);
                return col;
            }
            ENDCG
        }
    }
}
