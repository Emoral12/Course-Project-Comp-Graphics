Shader "Custom/GlassOutline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Outline ("Outline Width", Range(0.00000005, 0.1)) = 0.005
        _GlassTex ("Texture", 2D) = "white" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _ScaleUV ("Scale", Range(1,20)) = 1
    }
    
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        GrabPass {}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize;
            sampler2D _GlassTex;
            float4 _GlassTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _ScaleUV;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // check if image needs to do  flip
                # if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0f;
                # else
                float scale = 1.0f;
                #endif

                o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;

                o.uvgrab.zw = o.vertex.zw;
                o.uv = TRANSFORM_TEX(v.uv, _GlassTex);
                o.uvbump = TRANSFORM_TEX(v.uv, _BumpMap);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvbump)).rg;
                float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
                i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;

                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                fixed4 tint = tex2D(_GlassTex, i.uv);
                col *= tint;
                return col;
            }
            ENDCG
        }
    }
    
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        ZWrite Off
        CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            struct Input
            {
                float2 uv_MainTex;
            };

            float _Outline;
            float4 _OutlineColor;
            void vert (inout appdata_full v)
            {
                v.vertex.xyz += v.normal * _Outline; 
            }

            sampler2D _MainTex;
            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Emission = _OutlineColor.rgb;
            }
        ENDCG

        Pass
        {
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : POSITION;
                fixed4 color : COLOR;
            };

            float _Outline;
            float4 _OutlineColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 norm =  normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                float2 offset = TransformViewToProjection(norm.xy);

                o.pos.xy += offset * o.pos.z * _Outline;
                o.pos = _OutlineColor;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }

        ZWrite On
        
        CGPROGRAM
            #pragma surface surf Lambert
            struct Input
            {
                float2 uv_MainTex;
            };

            sampler2D _MainTex;
            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
