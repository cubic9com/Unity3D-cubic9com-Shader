// <https://github.com/cubic9com/Unity3D-cubic9com-Shader>

Shader "cubic9com/CRTGlitchShader"
{
	Properties
	{
		_MainTex("Main", 2D) = "white"{}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			#define PI 3.1415926535 

			sampler2D _MainTex;

			fixed random(fixed2 uv)
			{
				return frac(sin(dot(uv, fixed2(12.9898, 78.233))) * 43758.5453);
			}

			// calculate offset for wave effect
			fixed4 xOffset(fixed2 uv, fixed phaseOffset)
			{
				fixed r = random(fixed2(0, uv.y) * _Time.y);
				int direction = step(r, 0.5) * 2 - 1;
				fixed xOffsetFactor = 0.008 * sin(_Time.y) * cos(_Time.w * 0.3);

				fixed phase = 10 * PI * uv.y + 10 * fmod(_Time.y + phaseOffset, PI * 2);
				fixed xOffset = xOffsetFactor * sin(phase);
				xOffset *= direction;
				fixed2 newUV = fixed2(uv.x + xOffset, uv.y);

				return tex2D(_MainTex, newUV);
			}

			// return true if the position is in the range of line noise
			bool isInTheRange(fixed uvY)
			{
				bool ret = false;
				fixed y1 = fmod(_Time.y / 2, 2);
				fixed y2 = y1 - 0.1;
				fixed y3 = y2 - 0.03;

				if ((uvY > y1) && (uvY < y1 + 0.002))
				{
					ret = true;
				}
				else if ((uvY > y2) && (uvY < y2 + 0.002))
				{
					ret = true;
				}
				else if ((uvY > y3) && (uvY < y3 + 0.002))
				{
					ret = true;
				}

				return ret;
			}

			fixed3 frag(v2f_img i) : SV_Target
			{
				fixed3 rgb;
				fixed3 tex;
				fixed n = random(i.uv * _Time.y);
				fixed3 noise = fixed3(n, n, n);

				if (isInTheRange(i.uv.y))
				{
					// line noise
					rgb = noise;
				}
				else
				{
					// wave effect
					tex.r = xOffset(i.uv, 0).r;
					tex.g = xOffset(i.uv, 0.04 * PI).g;
					tex.b = xOffset(i.uv, 0.08 * PI).b;

					// vignette
					fixed2 dist = (i.uv - 0.5) * 1.55;
					fixed vignetteFactor = 1 - dot(dist, dist);

					// stripe
					fixed stripe = floor(frac(i.uv.y * -96) - 0.5);

					// result
					rgb = tex * vignetteFactor + 0.1 * noise + 0.5 * stripe;
				}

				return rgb;
			}

			ENDCG
		}
	}
}