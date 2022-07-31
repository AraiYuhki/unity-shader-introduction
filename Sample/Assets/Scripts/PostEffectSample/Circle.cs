using UnityEngine;

namespace Sample
{
	[ExecuteInEditMode]
	public class Circle : PostEffect
	{
		[SerializeField]
		private Vector2 position = Vector2.zero;
		[SerializeField]
		private float radius = 0.2f;
		[SerializeField]
		private float antialias = 0.01f;

		private Vector2 aspect;

		private void Start() => aspect = new Vector2((float)Screen.width / Screen.height, 1.0f);

		private void Update()
		{
			var pos = position * aspect;
			material.SetVector(ShaderUtil.GetPropertyId(ShaderProperty.Param), new Vector4(pos.x, pos.y, radius, antialias));
		}

	}
}
