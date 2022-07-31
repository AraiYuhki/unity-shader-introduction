Shader "Sample/PostEffect/SpikeNoise"
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
            #include "../libs/Utility.cginc"
            
            sampler2D _MainTex;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float value = spikeNoise(i.uv) * random(_Time.xy) * step(0.99, tan(_Time.y));
                fixed4 col = tex2D(_MainTex, i.uv + float2(value, 0.0));
                return col;
            }
            ENDCG
        }
    }
}
