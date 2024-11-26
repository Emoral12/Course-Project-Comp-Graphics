Shader "Custom/GlassWithOutline"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 1, 1)
        _OutlineWidth ("Outline Width", Range(0.005, 0.1)) = 0.02
        _ScaleUV ("Normal Map Scale", Range(1, 10)) = 1
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" }
        GrabPass {}

        // Outline Pass
        Pass
        {
            Name "AuraOutline"
            Cull Front
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _OutlineWidth;
            float4 _OutlineColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            v2f vert(appdata v)
            {
                // Expand vertex position along normals
                float3 worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex + float4(worldNormal * _OutlineWidth, 0.0));
                o.color = _OutlineColor;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.color; // Output the outline color
            }
            ENDCG
        }

        // Glass Pass
        Pass
        {
            Name "Glass"
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vertGlass
            #pragma fragment fragGlass
            #include "UnityCG.cginc"

            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _ScaleUV;

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 uvgrab : TEXCOORD1;
                float2 uvbump : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            v2f vertGlass(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // UV for grab pass
                #if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0f;
                #else
                float scale = 1.0f;
                #endif

                o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
                o.uvgrab.zw = o.vertex.zw;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvbump = TRANSFORM_TEX(v.uv, _BumpMap);
                return o;
            }

            fixed4 fragGlass(v2f i) : SV_Target
            {
                // Apply bump offset
                half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvbump)).rg;
                float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
                i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;

                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                fixed4 tint = tex2D(_MainTex, i.uv);
                col *= tint;
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
