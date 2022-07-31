using UnityEngine;

namespace Sample
{
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

			Graphics.Blit(source, destination, material);
		}
	}
}
