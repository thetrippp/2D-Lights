// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "RaghavSuriyashekar/MeshShadowCaster"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        LOD 100
        ZWrite Off
	    Blend SrcAlpha OneMinusSrcAlpha 

        ColorMask 0

        Stencil
        {
            Ref 0
            Comp Always
            Pass IncrSat
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal: TEXCOORD1;
            };

            struct g2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal: TEXCOORD1;
                float4 color : COLOR;
            };


            sampler2D _MainTex;
            float4 _MainTex_ST;
            float extrusion;

            float3 lightPosition;

            v2f vert (appdata v)
            {
                // Dont do any operations like UnityObjectToClipPos in here because we will do it in the geometry shader.
                v2f o;
                o.vertex = v.vertex;
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }


            // GEOMETRY SHADER.
            // Magic!!
            [maxvertexcount(9)]
            void geom(triangle v2f IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f o;
                
                // "Outward Normals" used to calculate the local axis directions for assigning local normals to the generated
                // vertices. Necessary to calculate which meshes must be projected as a shadow.

                float3 west = normalize(cross(normalize(IN[0].vertex.xyz - IN[1].vertex.xyz), float3(0,0,1)));
                float3 north = normalize(cross(west, float3(0,0,1)));
                float3 east = -west;
                float3 south = -north;

                // Main Triangle ------------------------------------------- Main triangle of the base mesh.
                
                o.normal = south;
                float dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex)), south);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[0].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[0].vertex);
                o.uv = TRANSFORM_TEX(IN[0].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                o.normal = west;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[1].vertex)), west);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[1].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[1].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[1].vertex);
                o.uv = TRANSFORM_TEX(IN[1].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                o.normal = east;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[2].vertex)), east);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[2].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[2].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[2].vertex);
                o.uv = TRANSFORM_TEX(IN[2].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);

                //  Triangle 1 --------------------------------------------- Auxillary shadow mesh on first side.
                
                o.normal = south;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex)), south);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[0].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[0].vertex);
                //o.uv = TRANSFORM_TEX(IN[0].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                o.normal = west;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[1].vertex)), west);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[1].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[1].vertex))) * -20);
                else
                o.vertex = UnityObjectToClipPos(IN[1].vertex);
                //o.uv = TRANSFORM_TEX(IN[1].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                o.normal = west;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex)), west);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[0].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[0].vertex + west * extrusion);
                //o.uv = TRANSFORM_TEX(IN[0].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                //  Triangle 2 --------------------------------------------- Auxillary shadow mesh on second side.
                
                o.normal = south;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex)), south);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[0].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[0].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[0].vertex);
                //o.uv = TRANSFORM_TEX(IN[0].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                o.normal = east;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[2].vertex)), east);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[2].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[2].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[2].vertex);
                //o.uv = TRANSFORM_TEX(IN[2].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                o.normal = south;
                dotP = dot(normalize(lightPosition - mul(unity_ObjectToWorld,IN[2].vertex)), south);
                if(dotP < 0)
                    o.vertex = UnityObjectToClipPos(IN[2].vertex + mul(unity_WorldToObject, normalize(lightPosition - mul(unity_ObjectToWorld,IN[2].vertex))) * -20);
                else
                    o.vertex = UnityObjectToClipPos(IN[2].vertex + south * extrusion);
                //o.uv = TRANSFORM_TEX(IN[2].uv, _MainTex);
                o.color = float4(dotP, 0, 0,0);
                triStream.Append(o);
                
                // Necessary to repeat for every triangle in the mesh.
                triStream.RestartStrip();
            }

            fixed4 frag (g2f i) : SV_Target
            {
                // Returning white for now.
                //fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = fixed4(1,1,1,0);
                return col;
            }
            ENDCG
        }
    }
}
