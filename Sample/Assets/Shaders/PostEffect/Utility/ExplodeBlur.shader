Shader "PostEffect/ExplodeBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ForcusX("ForcusX", Float) = 0.5
        _ForcusY("ForcusY", Float) = 0.5
        _Power("Power", Float) = 0
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
            float4 _MainTex_TexelSize;
            float _ForcusX;
            float _ForcusY;
            float _Power;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 dir = i.uv - float2(_ForcusX, _ForcusY);
                float len = length(dir);
                dir = normalize(dir) * _MainTex_TexelSize.xy;
                dir *= len * _Power;
                fixed4 col = tex2D(_MainTex, i.uv) * 0.19;
                col.rgb += tex2D(_MainTex, i.uv + dir).rgb * 0.17;
                col.rgb += tex2D(_MainTex, i.uv + dir * 2.0).rgb * 0.15;
                col.rgb += tex2D(_MainTex, i.uv + dir * 3.0).rgb * 0.13;
                col.rgb += tex2D(_MainTex, i.uv + dir * 4.0).rgb * 0.11;
                col.rgb += tex2D(_MainTex, i.uv + dir * 5.0).rgb * 0.09;
                col.rgb += tex2D(_MainTex, i.uv + dir * 6.0).rgb * 0.07;
                col.rgb += tex2D(_MainTex, i.uv + dir * 7.0).rgb * 0.05;
                col.rgb += tex2D(_MainTex, i.uv + dir * 8.0).rgb * 0.03;
                col.rgb += tex2D(_MainTex, i.uv + dir * 9.0).rgb * 0.01;
                return col;
            }
            ENDCG
        }
    }
}
