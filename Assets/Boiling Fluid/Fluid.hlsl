
float3 hash33(float3 p3)
{
	p3 = frac(p3 * float3(443.897, 441.423, 437.195));
	p3 += dot(p3, p3.yxz + 19.19);
	return frac((p3.xxy + p3.yxx) * p3.zyx);
}

float DXY(float2 uv)
{
	float2 dx = abs(ddx(uv));
	float2 dy = abs(ddy(uv));
	return max(max(dx.x, dx.y), max(dy.x, dy.y));
}

float aaStep(float value, float threshold, float dv)
{
	return saturate((value - threshold) / dv + 0.5);
	//return saturate((value - threshold) / dv - value + 1.0);
}

// return distance, and cell id
void Voronoi2D_float(in float2 uv, in float NormalScale, in float Threshold, out float Value, out float2 Position, out float3 Normal)
{
	float2 n = floor(uv);
	float2 f = frac(uv);
	float2 p;
	float3 mData = 8.0;
	for(p.y = -1.0; p.y <= 1.0; p.y++)
	for(p.x = -1.0; p.x <= 1.0; p.x++)
	{
		float2 cell = n + p;
		float3 h = hash33(cell.xyx);
		float2 o = 0.5 + 0.5 * sin(_Time.y + radians(h.xy * 360.0));
		//float2 o = h.xy;
		float2 r = p - f + o;
		float k = frac(h.z - _Time.y * 3.0);
		float d = dot(r, r) + k;
		if(d < mData.x)
			mData = float3(d, cell);
	}
	Value = aaStep(1.0 - sqrt(mData.x), Threshold, DXY(uv));
	float2 offset = 0.5 + 0.5 * sin(_Time.y + radians(hash33(mData.yzy).xy * 360.0));
	//float2 offset = hash33(mData.yzy).xy;
	Position = mData.yz + offset;
	Normal.xy = (uv - Position) * NormalScale * Value;
	Normal.z = sqrt(1.0 - saturate(dot(Normal.xy, Normal.xy)));
}

void Voronoi3D_float(in float3 uvw, out float Distance, out float3 Position)
{
	float3 n = floor(uvw);
	float3 f = frac(uvw);
	float3 p;
	float4 m = 8.0;
	for(p.z = -1.0; p.z <= 1.0; p.z++)
	for(p.y = -1.0; p.y <= 1.0; p.y++)
	for(p.x = -1.0; p.x <= 1.0; p.x++)
	{
		//float3 g = float3(i, j, k);
		float3 cell = n + p;
		float3 o = hash33(cell);
		const float g = 1.22074408460575947536;
		const float3 a = 1.0 / float3(g, g * g, g * g * g);
		//float3 o = 0.5 + 0.5 * sin(dot(cell, a.yxz) * float3(10, 11, 13) * radians(360) + radians(float3(0, 120, 120)));
		//float3 o = 0.5 + 0.5 * sin(dot(cell, float3(10, 11, 13) * radians(360)) + radians(float3(0, 120, 120)));//* radians(360)
		float3 r = p - f + o;
		//float3 r = p - f + (0.5 + 0.5 * sin(_Time.y + radians(o * 360.0)));
		float d = dot(r, r);
		if(d < m.x)
			m = float4(d, cell);
	}
	Distance = sqrt(m.x);
	Position = m.yzw + hash33(m.yzw);
}