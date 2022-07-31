Shader "Sample/Custom/Bamp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTex("NormapTex", 2D) = "white" {}
        _AmbientTex("AmbientTex", CUBE) = "white" {}
        _Reflectivity("Reflectivity", Range(0.01, 1)) = 1.0 // ���˗�
        _Color("Color", Color) = (1, 1, 1, 1)
        _Specular("Specular", Color) = (1, 1, 1, 1) // �n�C���C�g�̐F(���C�g�̐F�ł�OK)
        _Shininess ("Shininess", Range(0.01, 1)) = 0.4 // �n�C���C�g�̉s��
        _ReflectRatio ("ReflectRatio", Range(0.01, 1)) = 0.5 // �f�荞�ݗ�
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("SrcFactor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("DstFactor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("BlendOp", Float) = 0
        [Enum(Off, 0, On, 1)]
        _ZWrite("ZWrite", Float) = 1
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Cull", Float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_BlendOp]
        ZWrite [_ZWrite]
        Cull [_Cull]
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
                float3 reverseViewVector : TECROOD3;
            };

            sampler2D _MainTex;
            sampler2D _NormalTex;
            samplerCUBE _AmbientTex;
            fixed4 _Color;
            fixed4 _Specular;
            float _Reflectivity;
            float _Shininess;
            float _ReflectRatio;
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
                // ���̋t�x�N�g�����擾
                o.reverseViewVector = ObjSpaceViewDir(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                // �S�Ă̖@���𐳋K������
                float3 normal = normalize(i.worldNormal);
                // �e�N�X�`������@�������擾����
                float3 normal2 = UnpackNormal(tex2D(_NormalTex, i.uv));
                // �ʖ@���ƃe�N�X�`���̖@�����u�����h����
                normal = BlendNormals(normal, normal2);

                float3 lightVector = normalize(i.lightVector);
                float3 reflectVector = normalize(reflect(-i.reverseViewVector, normal));
                // �A�̊|��������Z�o
                float shade = saturate(dot(normal, _WorldSpaceLightPos0.xyz));
                shade = shade * 0.5 + 0.5;
                shade = shade * shade;

                // �X�y�L�������Z�o
                float reflection = saturate(dot(lightVector, reflectVector));
                // ���ʔ��˂̋������Z�o
                float shininess = pow(500, _Shininess);
                // �ʂ荞�ސF���L���[�u�e�N�X�`������擾
                fixed3 mirrorColor = texCUBE(_AmbientTex, reflectVector);
                // �X�y�L�����̐F���Z�o
                fixed3 reflectionColor = _Specular.rgb * pow(reflection, shininess) * _Reflectivity;

                // ���C�e�B���O
                col.rgb =_LightColor0 * col.rgb * shade;
                // �f�荞�݂𔽉f
                col.rgb += mirrorColor * _ReflectRatio;
                // �X�y�L�����̐F�𔽉f
                col.rgb += reflectionColor;
                return col;
            }
            ENDCG
        }
    }
}
