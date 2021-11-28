Shader "Custom/Toon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ToonShadow("ToonShadow", 2D) = "whit" {}
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

            sampler2D _MainTex;
            sampler2D _ToonShadow;

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

            fixed4 _Color;

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
                fixed3 shadowColor = tex2D(_ToonShadow, float2(nl, 0));
                col.rgb = _LightColor0 * col.rgb * shadowColor;
                return col;
            }
            ENDCG
        }
    }
}
