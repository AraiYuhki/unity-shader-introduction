Shader "Sample/Mask/DoughnutMask"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Param("Param", Vector) = (0, 0, 0.2, 0) // ���S�_��X���W, ���S�_��Y���W, �����̉~�̔��a, �O���̉~�̔��a
        _Antialias ("Antialias", Float) = 0.01
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
            // {�e�N�X�`����}_TexelSize �Ńe�N�X�`���̃T�C�Y�Ȃǂ̏����擾���鎖���ł���
            float4 _MainTex_TexelSize; // (1 / width, 1 / height, width, height)
            float4 _Param;
            float _Antialias;

            fixed4 frag(v2f_img i) : SV_Target
            {
                // ��ʂ̃A�X�y�N�g����l�����A��ʂ̒��S��(0,0)�ɂȂ�悤�ɕ␳
                float2 uv = (i.uv * 2.0 - 1.0) * float2(_MainTex_TexelSize.z * _MainTex_TexelSize.y, 1.0);
                // �����Ȃ߂炩�ɂ���ꍇ�͈ȉ��̃R�[�h���g�p����
                float dist = distance(uv, _Param.xy);
                float value = 1 - smoothstep(_Param.w - _Antialias, _Param.w, dist);
                value *= smoothstep(_Param.z, _Param.z + _Antialias, dist);
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = lerp(fixed3(0, 0, 0), col.rgb, value);
                return col;
            }
            ENDCG
        }
    }
}
