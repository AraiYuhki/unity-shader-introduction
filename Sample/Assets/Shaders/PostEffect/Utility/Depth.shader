Shader "Sample/Utility/Depth"
{
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
            sampler2D _CameraDepthTexture;

            fixed4 frag (v2f_img i) : SV_Target
            {
                return SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
            }
            ENDCG
        }
    }
}
