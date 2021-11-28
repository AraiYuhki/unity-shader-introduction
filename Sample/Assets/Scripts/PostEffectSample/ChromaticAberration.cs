using UnityEngine;

public class ChromaticAberration : PostEffect
{
	[SerializeField]
	private Vector2 forcusPoint = Vector2.zero;
	[SerializeField]
	private float power = 0.005f;

	private int paramId = -1;

	private Vector2 aspect = Vector2.one;

	// Start is called before the first frame update
	void Start()
	{
		paramId = Shader.PropertyToID("_Param");
		aspect = new Vector2((float)Screen.width / Screen.height, 1.0f);
	}

	protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		var position = forcusPoint * aspect;
		material.SetVector(paramId, new Vector4(position.x, position.y, power, 0));
		base.OnRenderImage(source, destination);
	}
}
