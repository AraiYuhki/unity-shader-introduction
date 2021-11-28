Shader "PostEffect/PolarizedTransform"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Power("Power", Range(0.0, 1.0)) = 1.0
        _Start("Start", Float) = 0.75
        _RotateSpeed("RotateSpeed", Float) = 0
        _ThetaSpeed ("TheteSpeed", Float) = 0
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
            float _Power;
            float _Start;
            float _RotateSpeed;
            float _ThetaSpeed;

            // �X�N���[�������t���ɍ��W�ϊ�
            float2 ConvertPolarCordinate(float2 uv, half rSpeed, half thetaSpeed) 
            {
                const half PI2THETA = 1 / (3.1415926535 * 2);
                float2 res;

                // UV�l���ɍ��W�n�ɕϊ�
                uv = 2 * uv - 1;
                half r = 1 - sqrt(uv.x * uv.x + uv.y * uv.y);
                half theta = atan2(uv.y, uv.x) * PI2THETA + _Start;

                // �X�N���[���̂��߂̏���
                res.y = r + rSpeed * _Time;
                res.x = theta + thetaSpeed * _Time;
                return res;
            }

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 uv = ConvertPolarCordinate(i.uv, _ThetaSpeed, _RotateSpeed);
                uv = lerp(i.uv, uv, saturate(_Time.x - 0.1));
                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
