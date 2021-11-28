Shader "PostEffect/GlitchNoise"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScaleX("ScaleX", Range(0, 0.5)) = 0.2
        _ScaleY("ScaleY", Range(0, 0.5)) = 0.2
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
            float _ScaleX;
            float _ScaleY;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float offsetX = blockNoise(i.uv.y * 10.0);
                offsetX = offsetX * randomRange(_Time.z, -_ScaleX, _ScaleX);
                float offsetY = blockNoise(i.uv.x * 10.0);
                offsetY = offsetY * randomRange(_Time.w, -_ScaleY, _ScaleY);
                float2 uv = i.uv;
                float randX = step(0.7, random(_Time.xy) * sin(_Time.z));
                float randY = step(0.7, random(_Time.wz) * cos(_Time.w));
                uv.x = lerp(uv.x, uv.x + offsetX, randX);
                uv.y = lerp(uv.y, uv.y + offsetY, randY);
                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
