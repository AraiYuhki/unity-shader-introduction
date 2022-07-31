Shader "Sample/Custom/HalfLambert"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            };

            sampler2D _MainTex;
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
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 normal = normalize(i.worldNormal);
                // �A�̂���������Z�o
                float shade = saturate(dot(normal, _WorldSpaceLightPos0.xyz));
                shade = shade * 0.5 + 0.5;
                shade = shade * shade;

                // ���C�e�B���O
                col.rgb =_LightColor0 * col.rgb * shade;
                return col;
            }
            ENDCG
        }
    }
}
