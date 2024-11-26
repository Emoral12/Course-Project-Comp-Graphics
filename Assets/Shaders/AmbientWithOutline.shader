Shader "Custom/AmbientLightingWithOutline"
{
    Properties
    {
        _Color("Base Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
        _MainTex("Texture", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
        _Outline("Outline Width", Range(0.00000005, 0.1)) = 0.005
    }
    SubShader
    {
        // Base Pass for Ambient Lighting
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Properties
            float4 _Color;
            float4 _LightColor0;

            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 col : COLOR;
            };

            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float atten = 1.0;

                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

                o.col = float4(lightFinal * _Color.rgb, 1.0);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag(vertexOutput i) : COLOR
            {
                return i.col;
            }
            ENDCG
        }

        // Outline Pass
        Pass
        {
            Tags { "Queue" = "Overlay" }
            Cull Front
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _Outline;
            float4 _OutlineColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.pos = UnityObjectToClipPos(worldPos + float4(norm * _Outline, 0.0));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
