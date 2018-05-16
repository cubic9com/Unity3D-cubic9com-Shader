// <https://github.com/cubic9com/Unity3D-cubic9com-Shader>

Shader "cubic9com/ScrollingRainbowStripeShader"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			#define PI 3.1415926535 
			#define NUM_OF_STRIPE 10

			// HSV color to RGB color
			// ref. <https://forum.unity.com/threads/different-blending-modes-like-add-screen-overlay-changing-hue-tint.62507/#post-413034>
			fixed3 hsv_to_rgb(fixed3 HSV)
			{
				fixed3 RGB;

				fixed var_h = HSV.x * 6;
				fixed var_i = floor(var_h);
				fixed var_1 = HSV.z * (1.0 - HSV.y);
				fixed var_2 = HSV.z * (1.0 - HSV.y * (var_h - var_i));
				fixed var_3 = HSV.z * (1.0 - HSV.y * (1 - (var_h - var_i)));

				if (var_i == 0)
				{
					RGB = fixed3(HSV.z, var_3, var_1);
				}
				else if (var_i == 1)
				{
					RGB = fixed3(var_2, HSV.z, var_1);
				}
				else if (var_i == 2)
				{
					RGB = fixed3(var_1, HSV.z, var_3);
				}
				else if (var_i == 3)
				{
					RGB = fixed3(var_1, var_2, HSV.z);
				}
				else if (var_i == 4)
				{
					RGB = fixed3(var_3, var_1, HSV.z);
				}
				else
				{
					RGB = fixed3(HSV.z, var_1, var_2);
				}

				return (RGB);
			}

			fixed3 frag(v2f_img i) : SV_Target
			{
				fixed stripe = floor(frac(i.uv.y * NUM_OF_STRIPE + 2 * _Time.y) + 0.5);
				fixed3 rgb = hsv_to_rgb(fixed3(abs(sin(_Time.w / 12)), 1, 1));

				return stripe * rgb;
			}

			ENDCG
		}
	}
}
