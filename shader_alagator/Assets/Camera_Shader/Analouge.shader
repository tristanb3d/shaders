﻿Shader "Leasson/Camera/Glitch/Analouge"
{
    Properties
    {
        
        _MainTex ("-", 2D) = "" {}    
    }
    
	CGINCLUDE 
	#include "UnityCG.cginc"

	sampler2D _MainTex; 
	float2 _MainTex_TexelSize; 
	float2 _ScanLineJitter; 
	float2 _VerticalJump; 
	float _HorizontalShake; 
	float2 _ColorDrift; 
	float nrand(float x, float y)
	{
		return frac(sin(dot(float2(x,y),float2(12.9898,78.233)))*43758.5453);
	}

	half4 frag(v2f_img i): SV_Target
	{
		float u = i.uv.x; 
		float v = i.uv.y;
		float jitter = nrand(v, _Time.x)*2-1; 
		jitter *= step(_ScanLineJitter.y ,abs(jitter)) * _ScanLineJitter.x;

		//vert jump 
		float jump = lerp(v, frac(v+ _VerticalJump.y),_VerticalJump.x); 

		//horizontal shake 
		float shake = (nrand(_Time.x,2)-0.5)*_HorizontalShake; 
	
		//color Drift 

		float drift = sin(jump + _ColorDrift.y)*_ColorDrift.x; 
		half4 jsj = tex2D(_MainTex, frac(float2(u+ jitter + shake, jump)));
		half4 jsdj = tex2D(_MainTex, frac(float2(u+ jitter + shake + drift, jump)));

		return half4(jsj.r,jsdj.g, jsj.b,1);
		//jsj jump shape jump
	}
	ENDCG 

SubShader 
{
	Pass
	{
	ZTEST Always Cull Off ZWrite Off
	CGPROGRAM 
	#pragma vertex vert_img
	#pragma fragment frag 
	#pragma target 3.0
	ENDCG
	}
}
}
