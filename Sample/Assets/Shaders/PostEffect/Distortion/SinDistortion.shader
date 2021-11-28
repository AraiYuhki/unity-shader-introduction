Shader "Distortion/Sin"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Frequence("Frequence", Int) = 5
        _Power("Power", Range(0, 0.5)) = 0.02
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
            int _Frequence;
            float _Power;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                float distortion = frac(sin(_Time.y + uv.y * _Frequence) * _Power);
                uv.x += distortion;
                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
