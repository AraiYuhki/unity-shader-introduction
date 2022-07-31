Shader "Sample/Mask/Texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("Mask", 2D) = "white" {}
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
            sampler2D _MaskTex;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed mask = tex2D(_MaskTex, i.uv).r;
                col.rgb = lerp(fixed3(0, 0, 0), col.rgb, mask);
                return col;
            }
            ENDCG
        }
    }
}
