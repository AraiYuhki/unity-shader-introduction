Shader "PostEffect/Bipolarization"
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
                float value = Luminance(col.rgb);
                value = step(0.5, value);
                col.rgb = fixed3(value, value, value);
                return col;
            }
            ENDCG
        }
    }
}
