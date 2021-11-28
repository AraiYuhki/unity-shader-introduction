using DG.Tweening;
using UnityEngine;

public class Sonar : PostEffect
{
	[SerializeField]
	private float value = 0f;
	private int valueId = -1;
	private float time = 0f;

	Tween tween;
	void Start()
	{
		valueId = Shader.PropertyToID("_Value");
		tween = DOTween.To(() => value, v => value = v, 0.3f, 3.0f).SetEase(Ease.InCubic);
		tween.onComplete = () => value = -1.0f;
		tween.SetAutoKill(false);
	}

	private void Update()
	{
		time += Time.deltaTime;
		if (time >= 4.0f)
		{
			time = 0f;
			value = 0f;
			tween.Restart();
		}
	}

	protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat(valueId, value);
		base.OnRenderImage(source, destination);
	}
}
