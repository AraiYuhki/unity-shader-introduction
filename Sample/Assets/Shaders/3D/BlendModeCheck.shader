Shader "Unlit/BlendModeCheck"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("SrcFactor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("DstFactor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("BlendOp", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_BlendOp]
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

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
            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Color;
            }
            ENDCG
        }
    }
}
