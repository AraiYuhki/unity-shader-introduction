Shader "Sample/Filter/Sepia"
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
                col.rgb = fixed3(
                    col.r * 0.393 + col.g * 0.769 + col.b * 0.189,
                    col.r * 0.349 + col.g * 0.686 + col.b * 0.168,
                    col.r * 0.272 + col.g * 0.534 + col.b * 0.131
                );
                return col;
            }
            ENDCG
        }
    }
}
