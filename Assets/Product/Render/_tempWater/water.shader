Shader "Unlit/water"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _Updir ("Up", Vector) = (0,1,0,0)
    }
    SubShader
    {
        Tags { "Queue"="transparent" }
        Blend srcAlpha oneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            float4 _Tint;
            float3 _Updir;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 wpos : TEXCOORD2;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
                float3 biTangent : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct VertexNormalInputs
            {
	            float3 tangentWS;
	            float3 bitangentWS;
	            float3 normalWS;
            };

            VertexNormalInputs GetVertexNormalInputs(float3 normalOS, float4 tangentOS)
            {
	            VertexNormalInputs tbn;
	            // mikkts space compliant. only normalize when extracting normal at frag.
	            float sign = tangentOS.w * unity_WorldTransformParams.w;
	            tbn.normalWS = mul(normalOS, (float3x3)unity_WorldToObject);
	            tbn.tangentWS = mul((float3x3)unity_ObjectToWorld, tangentOS.xyz);
	            tbn.bitangentWS = cross(tbn.normalWS, tbn.tangentWS) * sign;
	            return tbn;
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.wpos = mul(unity_ObjectToWorld, v.vertex);
                VertexNormalInputs normarls = GetVertexNormalInputs(v.normal, v.tangent);
                o.normal = normarls.normalWS;
                o.tangent = normarls.tangentWS;
                o.biTangent = normarls.bitangentWS;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDir = normalize((_WorldSpaceCameraPos - i.wpos));
                float offset = dot(i.tangent, viewDir)*0.05;
                // offset = abs(offset);
                // return  float4(offset, offset, offset, 1);
                // 为了防止高度在动态角度露馅，做一些便宜效果会好一些
                float simulateHieght = abs(i.uv.x - (0.5+offset));
                // return key2;
                return float4(_Tint.rgb, saturate(_Tint.a * (1 - simulateHieght)));
            }
            ENDCG
        }
    }
}
