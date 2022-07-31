Shader "Sample/Distortion/Texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Distortion ("DistortionTex", 2D) = "gray" {}
        _Power ("Power", Range(0, 0.5)) = 0.02
        _ScrollSpeed ("ScrollSpeed", Vector) = (0.1, -0.1, -0.1, -0.1)
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
            sampler2D _Distortion;
            float _Power;
            float4 _ScrollSpeed;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float power = tex2D(_Distortion, i.uv).b * _Power;
                float offsetX = (tex2D(_Distortion, i.uv + _Time.y * _ScrollSpeed.xy).r - 0.5) * 2 * power;
                float offsetY = (tex2D(_Distortion, i.uv + _Time.y * _ScrollSpeed.zw).g - 0.5) * 2 * power;
                fixed4 col = tex2D(_MainTex, i.uv + float2(offsetX, offsetY));
                return col;
            }
            ENDCG
        }
    }
}
