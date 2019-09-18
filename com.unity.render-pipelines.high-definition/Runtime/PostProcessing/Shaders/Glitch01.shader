Shader "Hidden/Glitch01"
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
                float2 _Resolution;
                float _Threshold;
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

                float4 Frag(Varyings input) : SV_Target0
                {
                    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                    float4 color = LOAD_TEXTURE2D_X(_InputTexture,input.texcoord * _ScreenSize.xy);
                    float2 uv = input.texcoord;
                    uv *= _Resolution;
                    float2 seed = float2(fmod(_Seed * 65536,289),floor(_Seed * 65536 /289.0));
                    float2 iuv = floor(uv + seed);
                    float2 r = float2(hash(iuv),hash(iuv + float2(21.483,25.655)));
                    uv += r * _Resolution * 2.0;
                    r = r.x >= _Threshold || r.y >= _Threshold ? 0.5 : r ;
                    r = r * 2.0 - 1.0;
                    float2 s = r == 0 ? 1 : sign(r);
                    float2 st = frac(abs(input.texcoord * s + r));
                    float4 outColor = LOAD_TEXTURE2D_X(_InputTexture, st * _ScreenSize.xy);

                    uv *= 2.0;
                    iuv = floor(uv + seed);
                    float2 r2 = float2(hash(iuv),hash(iuv + float2(21.483,25.655)));
                    r2 = r2.x >= _Threshold || r2.y >= _Threshold ? 0.5 : r2;
                    r2 = r2 * 2.0 - 1.0;
                    s = r2 == 0 ? 1 : sign(r2);
                    float2 st2 = frac(abs(input.texcoord * s + r2));
                    outColor += r2.x == 0 || r2.y == 0 ? 0 : LOAD_TEXTURE2D_X(_InputTexture, st2 * _ScreenSize.xy);
                    outColor.rgb = saturate(outColor.rgb);
                    outColor.rgb = RgbToHsv(outColor.rgb);
                    outColor.rg += r;
                    outColor.rgb = HsvToRgb(outColor.rgb);
                    outColor.a = 1.0;
                    outColor = lerp(color,outColor,_Amount);
                    return outColor;
                }

            ENDHLSL
        }
    }
    Fallback Off
}
