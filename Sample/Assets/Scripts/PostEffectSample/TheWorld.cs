using UnityEngine;

[ExecuteInEditMode]
public class TheWorld : PostEffect
{
	[SerializeField]
	float innerRadius = 0f;
	[SerializeField]
	float outerRadius = 0f;
	[SerializeField]
	float polarInnerRadius = 0f;
	[SerializeField]
	float polarOuterRadius = 0f;
	[SerializeField]
	float antialias = 0f;
	[SerializeField]
	float polarAntialias = 0f;

	int innerRadiusId = -1;
	int outerRadiusId = -1;
	int polarInnerRadiusId = -1;
	int polarOuterRadiusId = -1;
	int polarAntialiasId = -1;
	int antialiasId = -1;

	// Start is called before the first frame update
	void Start()
	{
		innerRadiusId = Shader.PropertyToID("_InnerRadius");
		outerRadiusId = Shader.PropertyToID("_OuterRadius");
		polarInnerRadiusId = Shader.PropertyToID("_PolarInnerRadius");
		polarOuterRadiusId = Shader.PropertyToID("_PolarOuterRadius");
		polarAntialiasId = Shader.PropertyToID("_PolarAntialias");
		antialiasId = Shader.PropertyToID("_Antialias");
	}

	protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat(innerRadiusId, innerRadius);
		material.SetFloat(outerRadiusId, outerRadius);
		material.SetFloat(polarInnerRadiusId, polarInnerRadius);
		material.SetFloat(polarOuterRadiusId, polarOuterRadius);
		material.SetFloat(antialiasId, antialias);
		material.SetFloat(polarAntialiasId, polarAntialias);
		base.OnRenderImage(source, destination);
	}
}
