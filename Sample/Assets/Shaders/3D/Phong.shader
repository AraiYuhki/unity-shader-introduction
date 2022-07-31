Shader "Sample/Custom/Phong"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "gray" {}
        _Reflectivity("Reflectivity", Range(0.01, 1)) = 1.0 // 反射率
        _Specular("Specular", Color) = (1, 1, 1, 1) // ハイライトの色(ライトの色でもOK)
        _Shininess ("Shininess", Range(0.01, 1)) = 0.4 // ハイライトの鋭さ
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
                // 座標をワールド座標系に変換する
                o.vertex = UnityObjectToClipPos(v.vertex);
                // offsetとtilingを反映したUV値を取得する
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // 法線をワールド空間上の物に変換
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                // カメラへのオブジェクト空間ベクトル(光のベクトル)を取得
                o.lightVector = ObjSpaceLightDir(v.vertex);
                // 反射ベクトルを取得
                float3 revViewVector = ObjSpaceViewDir(v.vertex);
                o.reflectVector = reflect(-revViewVector, v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // 全ての法線を正規化する
                float3 normal = normalize(i.worldNormal);
                float3 lightVector = normalize(i.lightVector);
                float3 reflectVector = normalize(i.reflectVector);
                // 陰の掛かり方を算出
                float shade = saturate(dot(normal, _WorldSpaceLightPos0.xyz));
                shade = shade * 0.5 + 0.5;
                shade = shade * shade;

                // スペキュラを算出
                float reflection = saturate(dot(lightVector, reflectVector));
                // 鏡面反射の強さを算出
                float shininess = pow(500, _Shininess);
                // スペキュラ(反射光)の色を算出
                fixed3 reflectionColor = _Specular.rgb * pow(reflection, shininess) * _Reflectivity;

                // ライティング
                col.rgb =_LightColor0 * col.rgb * shade;
                // スペキュラの色を反映
                col.rgb += reflectionColor;
                return col;
            }
            ENDCG
        }
    }
}
