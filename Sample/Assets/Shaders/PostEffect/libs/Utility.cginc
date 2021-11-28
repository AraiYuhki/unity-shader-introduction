float random(float2 p) {
	return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
}

float randomRange(float2 p, float min, float max) {
	return lerp(min, max, random(p));
}

float blockNoise(float2 uv) {
	return random(floor(uv));
}

float perlinNoise(float2 uv) {
	fixed2 p = floor(uv);
	fixed2 f = frac(uv);
	fixed2 u = f * f * (3.0 - 2.0 * f);

	float v00 = random(p + fixed2(0, 0));
	float v10 = random(p + fixed2(1, 0));
	float v01 = random(p + fixed2(0, 1));
	float v11 = random(p + fixed2(1, 1));
	return lerp(lerp(dot(v00, f - fixed2(0, 0)), dot(v10, f - fixed2(1, 0)), u.x),
				lerp(dot(v01, f - fixed2(0, 1)), dot(v11, f - fixed2(1, 1)), u.x),
				u.y) + 0.5;
}

float fBmNoise(float2 uv) {
	float f = 0;
	fixed2 p = uv;
	f += 0.5000 * perlinNoise(p);
	p *= 2.01;
	f += 0.2500 * perlinNoise(p);
	p *= 2.02;
	f += 0.1250 * perlinNoise(p);
	p *= 2.03;
	f += 0.0625 * perlinNoise(p);
	return f;
}

float spikeNoise(float2 uv) {
	return sin(20.0f * uv.y) * ((uv.y - 1.0f) * (uv.y - 1.0f) + 1.0f);
}

// スクロール処理付き極座標変換
float2 ConvertPolarCordinate(float2 uv, half rSpeed, half thetaSpeed, float start)
{
	const half PI2THETA = 1 / (3.1415926535 * 2);
	float2 res;

	// UV値を極座標系に変換
	uv = 2 * uv - 1;
	half r = 1 - sqrt(uv.x * uv.x + uv.y * uv.y);
	half theta = atan2(uv.y, uv.x) * PI2THETA + start;

	// スクロールのための処理
	res.y = r + rSpeed * _Time;
	res.x = theta + thetaSpeed * _Time;
	return res;
}

// x >= y
#define GreaterEqual(x, y) step(y, x)

// x <= y
#define LessEqual(x, y) step(x, y)

// x > y
#define Greater(x, y) 1.0 - step(x, y)

// x < y
#define Less(x, y) 1.0 - step(y, x)

// x == y
#define Equal(x, y) 1 - abs(sign(x - y))

// x != y
#define NotEqual(x, y) abs(sign(x - y))

// 0 < a < 1
#define Range01Gl(a) abs(sign(a - ceil(saturate(a))))

// 0 <= a <= 1
#define Range01(a) 1.0 - abs(sign(a - saturate(a)))

// x < a < y
#define RangeIncEdge(a, x, y) step(x, a) * step(a, y)

// x <= a <= y
#define RangeExcEdge(a, x, y) (1 - step(x, a)) * (1 - step(a, y))
