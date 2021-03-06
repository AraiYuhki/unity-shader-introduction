using UnityEngine;

public class DepthOfField : PostEffect
{
	[SerializeField]
	private Material blurMaterial;

	private int blurTexId = -1;

	public void Start()
	{
		blurTexId = Shader.PropertyToID("_BlurTex");
	}

	protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		var tmp = RenderTexture.GetTemporary(Screen.width / 4, Screen.height / 4, 0, source.format);
		var tmp2 = RenderTexture.GetTemporary(Screen.width / 8, Screen.height / 8, 0, source.format);
		Graphics.Blit(source, tmp, blurMaterial);
		Graphics.Blit(tmp, tmp2, blurMaterial);

		material.SetTexture(blurTexId, tmp2);

		Graphics.Blit(source, destination, material);
		RenderTexture.ReleaseTemporary(tmp);
		RenderTexture.ReleaseTemporary(tmp2);
	}
}
