// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible colored shader.
// - no lighting
// - no lightmap support
// - no texture

Shader "Digicrafts/WireframeGrid/Transparent" {
Properties {	

	// Wireframe Properties
	[HDR]_WireframeColor ("_WireframeColor", Color) = (1,1,1,1)
	_WireframeTex ("_WireframeTex", 2D) = "white" {}
	[Enum(UV0,0,UV1,1)] _WireframeUV ("_WireframeUV", Float) = 0
	_WireframeSize ("_WireframeSize", Range(0.0, 10.0)) = 1.5
	[Toggle(_WIREFRAME_LIGHTING)]_WireframeLighting ("_WireframeLighting", Float) = 0
	[Toggle(_WIREFRAME_AA)]_WireframeAA ("_WireframeAA", Float) = 1
	[Toggle]_WireframeDoubleSided ("2 Sided", Float) = 0
	_WireframeMaskTex ("_WireframeMaskTex", 2D) = "white" {}
	_WireframeTexAniSpeedX ("_WireframeTexAniSpeedX", Float) = 0
	_WireframeTexAniSpeedY ("_WireframeTexAniSpeedY", Float) = 0
	_GridSpacing ("_GridSpacing", Float) = 0.5
	[Toggle]_GridSpacingScale ("_GridRelatedScale", Float) = 0
	[Toggle]_GridUseWorldspace ("_GridUseWorldspace", Float) = 0

	_WireframeAlphaCutoff ("_WireframeAlphaCutoff", Range(0.0, 1.0)) = 0
	[HideInInspector] _WireframeAlphaMode ("__WireframeAlphaMode", Float) = 0
	[HideInInspector] _WireframeCull ("__WireframeCull", Float) = 2
}

SubShader {

	Tags { "RenderType"="Transparent" "Queue"="Transparent"}

	Pass { 
		Name "Wireframe"	  
		Cull [_WireframeCull]
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature _WIREFRAME_AA
			#pragma shader_feature _WIREFRAME_ALPHA_NORMAL _WIREFRAME_ALPHA_TEX_ALPHA _WIREFRAME_ALPHA_TEX_ALPHA_INVERT _WIREFRAME_ALPHA_MASK

			#include "UnityCG.cginc"
			#include "Assets/Digicrafts/WireframeGrid/Shaders/Core/Core.cginc"

			uniform sampler2D _WireframeVertexTex;

			struct appdata {				
				float4 vertex : POSITION;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				fixed2 uv4 : TEXCOORD3;
			};		

			struct v2f {
				float4 pos : SV_POSITION;
				DC_WIREFRAME_COORDS(0,1)				
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				DC_WIREFRAME_TRANSFER_COORDS(o);
				return o;
			}
			fixed4 frag (v2f i) : COLOR
			{								
				fixed4 c = fixed4(1,1,1,0);
				DC_APPLY_WIREFRAME(c.rgb,c.a,i)
				return c;
			}

		ENDCG
	}
}
CustomEditor "WireframeGridTransparentShaderGUI"
}