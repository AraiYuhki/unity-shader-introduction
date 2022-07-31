Shader "Sample/PostEffect/ColorMixer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurTex ("BlurTex", 2D) = "white" {}
        _Power ("Power", Float) = 1.0
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
            sampler2D _BlurTex;
            float _Power;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed3 blur = tex2D(_BlurTex, i.uv).rgb;
                col.rgb += blur * _Power * Luminance(blur);
                col.rgb = saturate(col.rgb);
                return col;
            }
            ENDCG
        }
    }
}
