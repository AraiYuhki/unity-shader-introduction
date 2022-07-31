using UnityEngine;

namespace Sample
{
	[ExecuteInEditMode]
	public class StarMask : PostEffect
	{
		[SerializeField]
		private Vector2 position = Vector2.zero;
		[SerializeField, Range(0f, 1f)]
		private float antialias = 0.01f;
		[SerializeField]
		private int vertexNum = 5;
		[SerializeField]
		private float radius = 0.2f;
		[SerializeField, Range(0f, 1f)]
		private float dent = 0.5f;
		[SerializeField]
		private float angle = 180f;

		private int statusId = -1;
		private int dentId = -1;
		private int vertexCountId = -1;
		private int angleId = -1;
		private void Start()
		{
			statusId = Shader.PropertyToID("_Status");
			dentId = Shader.PropertyToID("_Dent");
			vertexCountId = Shader.PropertyToID("_VertexCount");
			angleId = Shader.PropertyToID("_Angle");
		}

		protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
		{
			material.SetVector(statusId, new Vector4(position.x, position.y, radius, antialias));
			material.SetFloat(dentId, dent);
			material.SetFloat(vertexCountId, vertexNum);
			material.SetFloat(angleId, angle);
			base.OnRenderImage(source, destination);
		}
	}
}
