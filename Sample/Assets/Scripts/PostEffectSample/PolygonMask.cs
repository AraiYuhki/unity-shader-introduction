using UnityEngine;

[ExecuteInEditMode]
public class PolygonMask : PostEffect
{
	[SerializeField]
	private Vector2 position = Vector2.zero;
	[SerializeField]
	private float radius = 0.2f;
	[SerializeField]
	private int vertexNum = 3;
	[SerializeField]
	private float angle = 0f;
	[SerializeField]
	private float antialias = 0.01f;

	private Vector2 aspect = Vector2.one;
	private int statusId = -1;
	private int vertexCountId = -1;
	private int angleId = -1;

	void Start()
	{
		aspect = new Vector2((float)Screen.width / Screen.height, 1.0f);
		statusId = Shader.PropertyToID("_Status");
		vertexCountId = Shader.PropertyToID("_VertexCount");
		angleId = Shader.PropertyToID("_Angle");
	}

	protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		var position = this.position * aspect;
		material.SetVector(statusId, new Vector4(position.x, position.y, radius, antialias));
		material.SetInt(vertexCountId, vertexNum);
		material.SetFloat(angleId, angle);
		base.OnRenderImage(source, destination);
	}

}
