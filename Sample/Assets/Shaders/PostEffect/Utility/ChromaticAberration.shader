Shader "PostEffect/ChromaticAberration"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Param("Param", Vector) = (0.0, 0.0, 0.0, 0.0) // �œ_���WX, Y, �Y���̋���, ���g�p
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
            float4 _Param;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 uv = i.uv * 2.0 - 1.0;
                // �œ_����̌������擾
                float2 dir = _Param.xy - uv;
                // �œ_����̋������擾
                float len = length(dir);
                dir = normalize(dir) * _Param.z;
                // �ԁE�΁E�̏��ɂ��ꂪ�������Ȃ�
                fixed2 rColor = tex2D(_MainTex, i.uv + dir * len * 2.0).ra;
                fixed2 gColor = tex2D(_MainTex, i.uv + dir * len).ga;
                fixed2 bColor = tex2D(_MainTex, i.uv).ba;
                // ���l�͔O�̈ו��ς�����Ă���
                fixed alpha = (rColor.y + gColor.y + bColor.y) * 0.3333;
                return fixed4(rColor.x, gColor.x, bColor.x, alpha);
            }
            ENDCG
        }
    }
}
