Shader "Sample/PostEffect/EdgeFilter"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Threshold("Threshold", Float) = 0.0
        _EdgeColor("EdgeColor", Color) = (0, 0, 0, 1.0)
        [Toggle]_LineView("LineView", Int) = 0
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
            float _Sensitivty;
            float _Threshold;
            float4 _EdgeColor;
            float4 _MainTex_TexelSize;
            int _LineView;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 duv = _MainTex_TexelSize.xy;
                float d0 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv - duv);
                float d1 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv + duv);
                float d2 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv + float2(duv.x, -duv.y));
                float d3 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv + float2(-duv.x, duv.y));
                float cg1 = d1 - d0;
                float cg2 = d3 - d2;
                float edge = sqrt(cg1 * cg1 + cg2 * cg2);
                float center = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                edge = 1 - step(edge, _Threshold * center);
                fixed4 col = tex2D(_MainTex, i.uv);
                if (_LineView == 0) {
                    col.rgb = fixed3(edge, edge, edge);
                }
                else {
                    col.rgb = lerp(col.rgb, _EdgeColor.rgb, edge);
                }
                return col;
            }
            ENDCG
        }
    }
}
