// <https://github.com/cubic9com/Unity3D-cubic9com-Shader>

Shader "cubic9com/GHContributionsShader"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			#define NUM_OF_RECT 32

			// calculate random value
			fixed rand(fixed2 st)
			{
				return frac(sin(dot(st, fixed2(12.9898, 78.233))) * 43758.5453);
			}

			// draw rectangle
			fixed3 rect(fixed2 uv, fixed n, fixed2 st)
			{
				fixed3 rgb;
				fixed offset = rand(uv) * 5;
				fixed delta = (1 + sin(_Time.y * 3 + offset)) * 0.5;

				fixed size = 0.5 + 0.8 * 0.5;
				st = step(st, size) * step(1.0 - st, size);

				if (st.x * st.y == 0)
				{
					rgb = fixed3(1, 1, 1);
				}
				else
				{
					rgb = fixed3(0.1176, 0.4078, 0.1376) + delta * fixed3(1, 1, 1);
				}

				return rgb;
			}

			fixed3 frag(v2f_img i) : SV_Target
			{
				fixed2 st = frac(i.uv * NUM_OF_RECT);

				return rect((floor(i.uv * NUM_OF_RECT) + 0.5) / NUM_OF_RECT, NUM_OF_RECT, st);
			}

			ENDCG
		}
	}
}
