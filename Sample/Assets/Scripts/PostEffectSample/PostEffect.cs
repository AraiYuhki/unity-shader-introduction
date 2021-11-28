using UnityEngine;

[RequireComponent(typeof(Camera)), ExecuteInEditMode]
public class PostEffect : MonoBehaviour
{
	[SerializeField]
	protected Material material;

	public Material Material
	{
		get => material;
		set => material = value;
	}

	protected virtual void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (material == null)
		{
			Graphics.Blit(source, destination);
			return;
		}
		source.wrapMode = TextureWrapMode.Mirror;
		Graphics.Blit(source, destination, material);
	}
}
