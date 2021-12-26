Shader "Unlit/Basic2DLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        
        Pass
        {
			Tags { "LightMode"="ForwardBase" }
            
            CGPROGRAM
			
			#pragma multi_compile_fwdbase	
			
			#pragma vertex vert
			#pragma fragment frag
			
            #include "UnityLightingCommon.cginc"
            #include "UnityCG.cginc"
			
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 wposxy : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.wposxy = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return float4(0, 0, 0, 0);
            }
            ENDCG
        }
        
        Pass
        {
			Tags { "LightMode"="ForwardAdd" }
            Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			
			#pragma multi_compile_fwdadd	
			
			#pragma vertex vert
			#pragma fragment frag
			
            #include "UnityLightingCommon.cginc"
            #include "UnityCG.cginc"
			
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 wposxy : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.wposxy = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                float3 test = 1/length(_WorldSpaceLightPos0.xy - i.wposxy) - 0.2;
                col.rgb *= test;
                float a = col.r * col.g * col.b;
                col = saturate(col);
                return float4(test, a);
            }
            ENDCG
        }
    }
}
