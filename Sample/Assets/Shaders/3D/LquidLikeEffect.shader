Shader "Unlit/LquidLikeEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} // r:ベースの形状 g:ベースの形状に揺らぎを与えるマスク b:形状の中の模様
        _BaseColor ("BaseColor", Color) = (0, 0, 0, 1)
        _LineColor ("LineColor", Color) = (1, 1, 1, 1)
        _ScrollSpeed ("ScrollSpeed", Float) = 0.2
        _OutlineBlur ("OutlineBlur", Float) = 0.2
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor ("SrcFactor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor ("DstFactor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp ("BlendOp", Float) = 0
    }
    SubShader
    {
        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        ZWrite off
        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_BlendOp]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "../libs/Utility.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _BaseColor;
            fixed4 _LineColor;
            float _ScrollSpeed;
            float _OutlineBlur;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            
            float4 frag(v2f i) : SV_Target
            {
                // ブレンドシェイプ
                fixed r = tex2D(_MainTex,i.uv).r;

                float scrollProgress = actualNumberDiscard(_Time.y, _ScrollSpeed);
                i.uv.y -= scrollProgress;
                fixed2 gb = tex2D(_MainTex, i.uv).gb;

                // α値を調整
                fixed shape = ((r * 2.0f) - 1.0f) + gb.x;
                shape = clamp(shape, 0, 1);

                // 内部で色を変動させる
                float4 col = float4(1.0, 1.0, 1.0, 1.0);
                col.rgb = lerp(_LineColor.rgb, _BaseColor.rgb, shape - gb.y);
                col.a = smoothstep(0.0f, _OutlineBlur, shape);

                return col;
            }
            ENDCG
        }
    }
}
