Shader "Hidden/Distortion"
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
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
                #include "Assets/NoiseShader/HLSL/SimplexNoise2D.hlsl"

                TEXTURE2D_X(_InputTexture);

                float _Amount;

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

                float4 Frag(Varyings input) : SV_Target0
                {
                    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                    float h = hash(input.texcoord.y * 5);
                    float iuv = input.texcoord.y * 30.0 * h;
                    float2 uv = input.texcoord + snoise(iuv) * _Amount * 0.1;
                    uv = frac(uv);
                    float4 outColor = LOAD_TEXTURE2D_X(_InputTexture, uv * _ScreenSize.xy);
                    outColor.a = 1.0;
                    return outColor;
                }

            ENDHLSL
        }
    }
    Fallback Off
}
