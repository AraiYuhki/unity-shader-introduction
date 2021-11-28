Shader "Custom/PhongPlus"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _AmbientTex("AmbientTex", CUBE) = "white" {}
        _Reflectivity("Reflectivity", Range(0.01, 1)) = 1.0 // 反射率
        _Specular("Specular", Color) = (1, 1, 1, 1) // ハイライトの色(ライトの色でもOK)
        _Shininess ("Shininess", Range(0.01, 1)) = 0.4 // ハイライトの鋭さ
        _ReflectRatio ("ReflectRatio", Range(0.01, 1)) = 0.5 // 映り込み率
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
            // make fog work
            #pragma multi_compile_fog
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 lightVector : TEXCOORD2;
                float3 reflectVector : TECROOD3;
            };

            sampler2D _MainTex;
            samplerCUBE _AmbientTex;
            fixed4 _Specular;
            float _Reflectivity;
            float _Shininess;
            float _ReflectRatio;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.lightVector = ObjSpaceLightDir(v.vertex);
                float3 revViewVector = ObjSpaceViewDir(v.vertex);
                o.reflectVector = reflect(-revViewVector, v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 normal = normalize(i.worldNormal);
                float3 lightVector = normalize(i.lightVector);
                float3 reflectVector = normalize(i.reflectVector);
                float shade = saturate(dot(normal, _WorldSpaceLightPos0.xyz));
                shade = shade * 0.5 + 0.5;
                shade = shade * shade;

                float reflection = saturate(dot(lightVector, reflectVector));
                float shininess = pow(500, _Shininess);
                fixed3 mirrorColor = texCUBE(_AmbientTex, reflectVector);
                fixed3 reflectionColor = _Specular.rgb * pow(reflection, shininess) * _Reflectivity;

                col.rgb =_LightColor0 * col.rgb * shade;
                col.rgb += mirrorColor * _ReflectRatio;
                col.rgb += reflectionColor;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
