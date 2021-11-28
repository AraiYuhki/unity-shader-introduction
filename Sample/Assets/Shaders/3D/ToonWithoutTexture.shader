Shader "Custom/ToonWithoutTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DivideNum ("DevideNum", Float) = 5
    }
    SubShader
    {
        Tags {
            "RenderType"="Opaque"
            "LightMode"="ForwardBase"
        }
        Pass {
            Cull Back
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            float _DivideNum;
            float _Threshold;

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 normal = normalize(i.worldNormal);
                float nl = clamp(dot(normal, lightDir), 0, 1);
                nl = nl * 0.5 + 0.5;
                nl = nl * nl;
                nl = floor(nl * _DivideNum) / _DivideNum;
                nl = saturate(nl);
                col.rgb = _LightColor0 * col.rgb * fixed3(nl, nl, nl);
                return col;
            }
            ENDCG
        }
    }
}
