Shader "Sample/PostEffect/HighLuminuncePicker"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Threshold("Threshold", Range(0, 0.99)) = 0.7
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
            float _Threshold;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float value = step(_Threshold, Luminance(col.rgb));
                col.rgb = lerp(fixed3(0, 0, 0), col.rgb, value);
                return col;
            }
            ENDCG
        }
    }
}
