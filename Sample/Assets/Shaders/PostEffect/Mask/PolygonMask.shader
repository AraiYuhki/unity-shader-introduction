Shader "Mask/Polygon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Status ("Status", Vector) = (0.5, 0.5, 0.2, 0) // XYç¿ïW, îºåa
        _VertexCount ("VertexCount", Int) = 6
        _Angle("Angle", Range(0, 359.0)) = 0
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
            #include "../libs/SimpleMask.cginc"
            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float4 _Status;
            int _VertexCount;
            float _Angle;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 position = i.uv * 2.0 - 1.0;
                position += _Status.xy;
                position *= float2(_MainTex_TexelSize.z * _MainTex_TexelSize.y, 1.0);
                float a = atan2(position.x, position.y) + _Angle * DEG2RAD;
                float r = TWO_PI / (float)_VertexCount;
                float d = cos(floor(0.5 + a / r) * r - a) * length(position);
                float value = 1.0 - smoothstep(_Status.z, _Status.z + _Status.w, d);
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = lerp(fixed3(0, 0, 0), col.rgb, value);
                return col;
            }
            ENDCG
        }
    }
}
