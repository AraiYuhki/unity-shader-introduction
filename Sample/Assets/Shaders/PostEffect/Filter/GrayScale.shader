Shader "Filter/GrayScale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed luminance = col.r * 0.299 + col.g * 0.587 + col.b * 0.114; // Luminance(col.rgb);?Ɠ???
                col.rgb = fixed3(luminance, luminance, luminance);
                return col;
            }
            ENDCG
        }
    }
}
