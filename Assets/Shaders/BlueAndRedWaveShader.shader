// <https://github.com/cubic9com/Unity3D-cubic9com-Shader>

Shader "cubic9com/BlueAndRedWaveShader"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed3 frag(v2f_img i) : SV_Target
			{
				fixed3 rgb;

				fixed phase = i.uv.y * 20 - _Time.w * 4;
				fixed sinV = 0.05 * sin(phase);
				if (i.uv.x < sinV + 0.45)
				{
					rgb = fixed3(0, 0, 1);
				}
				else if (i.uv.x < sinV + 0.48)
				{
					rgb = fixed3(0, 0, 0.5);
				}
				else if (i.uv.x < sinV + 0.5)
				{
					rgb = fixed3(0, 0, 0.2);
				}
				else if (i.uv.x < sinV + 0.52)
				{
					rgb = fixed3(0.2, 0, 0);
				}
				else if (i.uv.x < sinV + 0.55)
				{
					rgb = fixed3(0.5, 0, 0);
				}
				else
				{
					rgb = fixed3(1, 0, 0);
				}

				return rgb;
			}

			ENDCG
		}
	}
}
