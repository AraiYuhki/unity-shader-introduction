using UnityEngine;

namespace Sample
{
	public class Blur : PostEffect
	{
		protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
		{
			// �k���������ꎞ�e�N�X�`����p�ӂ���
			var tmp = RenderTexture.GetTemporary(Screen.width / 2, Screen.height / 2, 0, source.format);
			var tmp2 = RenderTexture.GetTemporary(Screen.width / 4, Screen.height / 4, 0, source.format);
			var tmp3 = RenderTexture.GetTemporary(Screen.width / 6, Screen.height / 6, 0, source.format);
			// �������ݐ��ς��ڂ�������������
			Graphics.Blit(source, tmp, material);
			Graphics.Blit(tmp, tmp2, material);
			Graphics.Blit(tmp2, tmp3, material);

			// ���ʂ������o��
			base.OnRenderImage(tmp3, destination);
			// �������̉��
			RenderTexture.ReleaseTemporary(tmp);
			RenderTexture.ReleaseTemporary(tmp2);
			RenderTexture.ReleaseTemporary(tmp3);
		}
	}
}
