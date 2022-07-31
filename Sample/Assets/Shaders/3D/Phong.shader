Shader "Sample/Custom/Phong"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "gray" {}
        _Reflectivity("Reflectivity", Range(0.01, 1)) = 1.0 // ���˗�
        _Specular("Specular", Color) = (1, 1, 1, 1) // �n�C���C�g�̐F(���C�g�̐F�ł�OK)
        _Shininess ("Shininess", Range(0.01, 1)) = 0.4 // �n�C���C�g�̉s��
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "LightMode"="ForwardBase"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 lightVector : TEXCOORD2;
                float3 reflectVector : TECROOD3;
            };

            sampler2D _MainTex;
            fixed4 _Specular;
            float _Reflectivity;
            float _Shininess;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                // ���W�����[���h���W�n�ɕϊ�����
                o.vertex = UnityObjectToClipPos(v.vertex);
                // offset��tiling�𔽉f����UV�l���擾����
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // �@�������[���h��ԏ�̕��ɕϊ�
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                // �J�����ւ̃I�u�W�F�N�g��ԃx�N�g��(���̃x�N�g��)���擾
                o.lightVector = ObjSpaceLightDir(v.vertex);
                // ���˃x�N�g�����擾
                float3 revViewVector = ObjSpaceViewDir(v.vertex);
                o.reflectVector = reflect(-revViewVector, v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // �S�Ă̖@���𐳋K������
                float3 normal = normalize(i.worldNormal);
                float3 lightVector = normalize(i.lightVector);
                float3 reflectVector = normalize(i.reflectVector);
                // �A�̊|��������Z�o
                float shade = saturate(dot(normal, _WorldSpaceLightPos0.xyz));
                shade = shade * 0.5 + 0.5;
                shade = shade * shade;

                // �X�y�L�������Z�o
                float reflection = saturate(dot(lightVector, reflectVector));
                // ���ʔ��˂̋������Z�o
                float shininess = pow(500, _Shininess);
                // �X�y�L����(���ˌ�)�̐F���Z�o
                fixed3 reflectionColor = _Specular.rgb * pow(reflection, shininess) * _Reflectivity;

                // ���C�e�B���O
                col.rgb =_LightColor0 * col.rgb * shade;
                // �X�y�L�����̐F�𔽉f
                col.rgb += reflectionColor;
                return col;
            }
            ENDCG
        }
    }
}
