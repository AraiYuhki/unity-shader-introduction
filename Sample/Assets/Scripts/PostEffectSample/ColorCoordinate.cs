using UnityEngine;
using UnityEngine.UI;

namespace Sample
{
	public class ColorCoordinate : PostEffect
	{
		[SerializeField, Range(0, 10)]
		private float brightness = 1.0f;
		[SerializeField, Range(-10f, 10f)]
		private float saturation = 1.0f;
		[SerializeField, Range(-1f, 10f)]
		private float contrast = 1.0f;

		[SerializeField]
		private Text label;

		private int brightnessId = -1;
		private int saturationId = -1;
		private int contrastId = -1;

		// Start is called before the first frame update
		void Start()
		{
			brightnessId = Shader.PropertyToID("_Bright");
			saturationId = Shader.PropertyToID("_Saturation");
			contrastId = Shader.PropertyToID("_Contrast");
		}

		private void Update()
		{
			label.text = $"明度: {brightness}\n彩度: {saturation}\nコントラスト: {contrast}";
		}

		protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
		{
			material.SetFloat(brightnessId, brightness);
			material.SetFloat(saturationId, saturation);
			material.SetFloat(contrastId, contrast);
			base.OnRenderImage(source, destination);
		}
	}
}
