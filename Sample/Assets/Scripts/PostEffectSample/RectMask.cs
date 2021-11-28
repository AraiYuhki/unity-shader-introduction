using UnityEngine;

[ExecuteInEditMode]
public class RectMask : PostEffect
{
	[SerializeField]
	private Vector2 leftUpPosition = Vector2.one * -0.2f;
	[SerializeField]
	private Vector2 rightButtomPosition = Vector2.one * 0.2f;

	private Vector2 aspect;

	// Start is called before the first frame update
	void Start() => aspect = new Vector2((float)Screen.width / Screen.height, 1.0f);

	// Update is called once per frame
	void Update()
	{
		var lu = leftUpPosition * aspect;
		var rb = rightButtomPosition * aspect;
		material.SetVector(ShaderUtil.GetPropertyId(ShaderProperty.Param), new Vector4(lu.x, lu.y, rb.x, rb.y));
	}
}
