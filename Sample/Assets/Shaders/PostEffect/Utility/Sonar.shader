Shader "PostEffect/Sonar"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (0, 1.0, 1.0, 1.0)
        _Value ("Value", Range(0, 0.3)) = 0
        _Threshold ("Threshold", Float) = 0.001
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
            sampler2D _CameraDepthTexture;
            float4 _Color;
            float _Value;
            float _Threshold;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                depth = Linear01Depth(depth);
                float value = smoothstep(_Value - _Threshold, _Value, depth) * (1 - smoothstep(_Value, _Value + _Threshold, depth));
                col.rgb += _Color.rgb * value;
                return col;
            }
            ENDCG
        }
    }
}
