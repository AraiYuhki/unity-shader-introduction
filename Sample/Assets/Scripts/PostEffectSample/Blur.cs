using UnityEngine;

namespace Sample
{
	public class Blur : PostEffect
	{
		protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
		{
			// 縮小させた一時テクスチャを用意する
			var tmp = RenderTexture.GetTemporary(Screen.width / 2, Screen.height / 2, 0, source.format);
			var tmp2 = RenderTexture.GetTemporary(Screen.width / 4, Screen.height / 4, 0, source.format);
			var tmp3 = RenderTexture.GetTemporary(Screen.width / 6, Screen.height / 6, 0, source.format);
			// 書き込み先を変えつつぼかし処理を入れる
			Graphics.Blit(source, tmp, material);
			Graphics.Blit(tmp, tmp2, material);
			Graphics.Blit(tmp2, tmp3, material);

			// 結果を書き出す
			base.OnRenderImage(tmp3, destination);
			// メモリの解放
			RenderTexture.ReleaseTemporary(tmp);
			RenderTexture.ReleaseTemporary(tmp2);
			RenderTexture.ReleaseTemporary(tmp3);
		}
	}
}
