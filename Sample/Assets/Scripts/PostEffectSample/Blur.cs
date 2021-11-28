using UnityEngine;

public class Blur : PostEffect
{
	[SerializeField]
	private int blurLevel = 1;

	protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{

		var tmp = RenderTexture.GetTemporary(Screen.width / 2, Screen.height / 2, 0, source.format);
		var tmp2 = RenderTexture.GetTemporary(Screen.width / 4, Screen.height / 4, 0, source.format);
		var tmp3 = RenderTexture.GetTemporary(Screen.width / 6, Screen.height / 6, 0, source.format);
		Graphics.Blit(source, tmp, material);
		Graphics.Blit(tmp, tmp2, material);
		Graphics.Blit(tmp2, tmp3, material);

		base.OnRenderImage(tmp3, destination);
		RenderTexture.ReleaseTemporary(tmp);
		RenderTexture.ReleaseTemporary(tmp2);
		RenderTexture.ReleaseTemporary(tmp3);
	}
}
