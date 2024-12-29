Shader "RaghavSuriyashekar/LightShader"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        LOD 100
        
	    ZWrite Off
	    Blend SrcAlpha OneMinusSrcAlpha 


        Stencil
        {
            Ref 0
            Comp Equal
            //Pass IncrSat
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
            };

            float4 baseColor;
            float intensity;
            float fallOff;
            float maxAngle;
            int useRadialFalloff;
            int useAngularFalloff;

            float smoothstep(float edge0, float edge1, float x) 
            {
                float t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
                return t * t * (3.0 - 2.0 * t);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = baseColor;
                col *= intensity;
                float dist = clamp(distance(i.uv, float2(0,0)), 0.0, 1.0);
                float radF = pow(1.0 - dist, fallOff);

                float angle = atan2(i.uv.y, i.uv.x) * 57.29578;
                float angF = 1 - smoothstep(0, maxAngle, abs(angle));

                if(useRadialFalloff == 1)
                col *= radF;
                if(useAngularFalloff == 1)
                col *= angF;

                col.a = Luminance(float3(col.r, col.g, col.b));
               


                return col;
            }
            ENDCG
        }
    }
}
