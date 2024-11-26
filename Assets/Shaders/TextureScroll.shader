Shader "Custom/TextureScroll"
{
    Properties
    {
        _MainTex ("Static", 2D) = "white" {}
        _OverlayTex ("More Static", 2D) = "white" {}
        _ScrollX ("Scroll X",   Range(-15,15)) = 1
        _ScrollY ("Scroll Y",   Range(-15,15)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _OverlayTex;
        float _ScrollX;
        float _ScrollY;
        
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            _ScrollX *= _Time;
            _ScrollY *= _Time;
            float3 main = (tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb;
            float3 secondary = (tex2D(_OverlayTex, IN.uv_MainTex + float2(_ScrollX/2.0, _ScrollY/2.0))).rgb;
            o.Albedo = (main + secondary)/2.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
