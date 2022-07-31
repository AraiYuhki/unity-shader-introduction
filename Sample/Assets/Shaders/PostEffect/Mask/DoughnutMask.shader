Shader "Sample/Mask/DoughnutMask"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Param("Param", Vector) = (0, 0, 0.2, 0) // 中心点のX座標, 中心点のY座標, 内側の円の半径, 外側の円の半径
        _Antialias ("Antialias", Float) = 0.01
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
            // {テクスチャ名}_TexelSize でテクスチャのサイズなどの情報を取得する事ができる
            float4 _MainTex_TexelSize; // (1 / width, 1 / height, width, height)
            float4 _Param;
            float _Antialias;

            fixed4 frag(v2f_img i) : SV_Target
            {
                // 画面のアスペクト比を考慮しつつ、画面の中心が(0,0)になるように補正
                float2 uv = (i.uv * 2.0 - 1.0) * float2(_MainTex_TexelSize.z * _MainTex_TexelSize.y, 1.0);
                // 縁をなめらかにする場合は以下のコードを使用する
                float dist = distance(uv, _Param.xy);
                float value = 1 - smoothstep(_Param.w - _Antialias, _Param.w, dist);
                value *= smoothstep(_Param.z, _Param.z + _Antialias, dist);
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = lerp(fixed3(0, 0, 0), col.rgb, value);
                return col;
            }
            ENDCG
        }
    }
}
