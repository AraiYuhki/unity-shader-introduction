Shader "Noise/fBm"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Frequency("Frequency", Float) = 1.0
        _ScrollSpeedX("ScrollSpeedX", Float) = 1
        _ScrollSpeedY("ScrollSpeedY", Float) = 1
    }
        SubShader
        {
            Cull Off
            ZWrite Off
            ZTest Always

            Pass
            {
                CGPROGRAM
                #pragma vertex vert_img
                #pragma fragment frag
                #pragma target 5.0

                #include "UnityCG.cginc"
                #include "../libs/Utility.cginc"

                sampler2D _MainTex;
                float _Frequency;
                float _ScrollSpeedX;
                float _ScrollSpeedY;

                fixed4 frag(v2f_img i) : SV_Target
                {
                    float value = fBmNoise(i.uv * _Frequency + float2(_ScrollSpeedX, _ScrollSpeedY) * _Time.y);
                    return fixed4(value, value, value, 1.0);
                }
                ENDCG
            }
        }
}
