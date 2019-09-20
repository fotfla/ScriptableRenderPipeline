Shader "Hidden/Glitch02"
{
    SubShader
    {

        Tags{ "RenderPipeline" = "HDRenderPipeline" }

        Pass
        {
            Cull Off ZWrite On ZTest Always Blend off

            HLSLPROGRAM
                #pragma target 4.5
                #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch

                #pragma vertex Vert
                #pragma fragment Frag

                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
                #include "Assets/NoiseShader/HLSL/SimplexNoise2D.hlsl"

                TEXTURE2D_X(_InputTexture);

                float _Amount;
                uint _Div;
                float _Intensity;
                uint _Seed;

                struct Attributes
                {
                    uint vertexID : SV_VertexID;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct Varyings{
                    float4 positionCS : SV_Position;
                    float2 texcoord : TEXCOORD0;
                    UNITY_VERTEX_OUTPUT_STEREO
                };

                Varyings Vert(Attributes input){
                    Varyings output;
                    UNITY_SETUP_INSTANCE_ID(input);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
                    output.positionCS = GetFullScreenTriangleVertexPosition(input.vertexID);
                    output.texcoord = GetFullScreenTriangleTexCoord(input.vertexID);
                    return output;
                }

                float hash(float2 uv){
                    return frac(45389.4893 * sin(dot(uv,float2(12.159,16.267))));
                }

                float2x2 rot(float a){
                    float c= cos(a),s = sin(a);
                    return float2x2(c,s,-s,c);
                }

                float4 Frag(Varyings input) : SV_Target0
                {
                    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                    float2 uv = input.texcoord;
                    float4 color = LOAD_TEXTURE2D_X(_InputTexture, uv * _ScreenSize.xy);
                    uint2 seed = uint2(fmod(_Seed * 65536 , 289),floor(_Seed * 65536 / 289));
                    float r = hash(_Seed + uint2(315,631));
                    uv = mul(rot(r * PI * 2.0),uv);
                    uint block = _Div == 0 ? 1 :_Div;
                    uv.x *= (float)block;
                    float2 iuv = floor(uv);
                    uv.x /= (float)block;
                    uv.y += (hash(iuv.x) * 2.0 - 1.0) * _Intensity;
                    uv = mul(rot(-r * PI * 2.0),uv);
                    // uv = frac(uv);
                    uv = clamp(uv,0,0.99);
                    float4 outColor = LOAD_TEXTURE2D_X(_InputTexture, uv * _ScreenSize.xy);
                    outColor = lerp(color,outColor,_Amount);
                    outColor.a = 1.0;
                    return outColor;
                }

            ENDHLSL
        }
    }
    Fallback Off
}
