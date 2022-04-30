using UnityEngine;
using UnityEngine.UI;

public class GlowFilter : PostEffect
{
	[SerializeField]
	private Material blurMaterial;
	[SerializeField]
	private Material colorPickMaterial;
	[SerializeField, Range(0f, 0.99f)]
	private float threshold = 0.7f;
	[SerializeField]
	private Text label;
	[SerializeField]
	private float blurSize = 2.0f;
	[SerializeField]
	private float power = 1.0f;

	[SerializeField]
	private bool enableBloom = false;

	private int thresholdId = -1;
	private int blurTexId = -1;
	private int blurSizeId = -1;
	private int powerId = -1;

	private void Start()
	{
		thresholdId = Shader.PropertyToID("_Threshold");
		blurTexId = Shader.PropertyToID("_BlurTex");
		blurSizeId = Shader.PropertyToID("_BlurSize");
		powerId = Shader.PropertyToID("_Power");
	}

	private void Update()
	{
		//label.text = string.Format("Threshold = {0:0.00}\nBlurSize = {1:0.00}\nPower = {2:0.00}", threshold, blurSize, power);
		if (label != null)
			label.text = enableBloom ? "Bloom On" : "Bloom Off";
	}

	protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (!enableBloom)
		{
			Graphics.Blit(source, destination);
			return;
		}
		blurMaterial.SetFloat(blurSizeId, blurSize);
		colorPickMaterial.SetFloat(thresholdId, threshold);
		var tmp = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, source.format);
		var blur = RenderTexture.GetTemporary(Screen.width / 4, Screen.height / 4, 0, source.format);
		Graphics.Blit(source, tmp, colorPickMaterial);
		Graphics.Blit(tmp, blur, blurMaterial);

		material.SetTexture(blurTexId, blur);
		material.SetFloat(powerId, power);

		base.OnRenderImage(source, destination);

		RenderTexture.ReleaseTemporary(tmp);
		RenderTexture.ReleaseTemporary(blur);
	}
}
