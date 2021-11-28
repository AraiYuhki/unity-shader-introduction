using UnityEngine;

public class SampleScene : MonoBehaviour
{
	private PostEffect postEffect = null;
	private Circle circleMask = null;
	private RectMask rectMask = null;
	private PolygonMask polygonMask = null;
	private Blur blur = null;
	private DepthOfField depthOfField;

	private void Start()
	{
		var camera = Camera.main;
		postEffect = camera.GetComponent<PostEffect>();
		circleMask = camera.GetComponent<Circle>();
		rectMask = camera.GetComponent<RectMask>();
		polygonMask = camera.GetComponent<PolygonMask>();
		blur = camera.GetComponent<Blur>();
		depthOfField = camera.GetComponent<DepthOfField>();
	}
}
