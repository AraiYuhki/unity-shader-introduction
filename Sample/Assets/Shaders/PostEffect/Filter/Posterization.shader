// 減色効果シェーダー
Shader "Sample/PostEffect/Posterization"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DivideNum("DivideNum", Float) = 1
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
            float _DivideNum;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = floor(col.rgb * _DivideNum) / _DivideNum;
                return col;
            }
            ENDCG
        }
    }
}
