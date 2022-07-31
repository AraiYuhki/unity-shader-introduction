Shader "Sample/PostEffect/ScanLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LineColor ("LineColor", Color) = (1, 1, 1, 0.3)
        _ScrollSpeed ("ScrollSpeed", Float) = 1.0
        _LineCount ("LineCount", Float) = 400.0
        _LineWidth ("LineWidth", Range(0.01, 1.0)) = 0.2
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
            float _ScrollSpeed;
            float _LineCount;
            float _LineWidth;
            float4 _LineColor;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float value = sin(_Time.y * _ScrollSpeed + i.uv.y * _LineCount) * 0.5 + 0.5;
                value = step(value, _LineWidth) * 0.5;
                col.rgb += value * _LineColor.rgb * _LineColor.a;
                return col;
            }
            ENDCG
        }
    }
}
