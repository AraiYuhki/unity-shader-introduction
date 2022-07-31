Shader "Sample/PostEffect/DepthOfField"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurTex ("Blur", 2D) = "black" {}
        _Forcus ("Forcus", Range(0.0, 1.0)) = 0.5
        _ForcusRange("ForcusRange", Range(0.0, 0.5)) = 0.05
    }
    SubShader
    {
        // No culling or depth
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"
            sampler2D _MainTex;
            sampler2D _BlurTex;
            sampler2D _CameraDepthTexture;
            float _Forcus;
            float _ForcusRange;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 blur = tex2D(_BlurTex, i.uv);
                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                depth = Linear01Depth(depth);
                float distance = clamp(abs(depth - _Forcus), 0, 1);
                distance = smoothstep(0, _ForcusRange, distance);
                return lerp(col, blur, distance);
            }
            ENDCG
        }
    }
}
