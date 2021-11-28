using DG.Tweening;
using UnityEngine;

public class ExplodeFilter : PostEffect
{
	int powerId = -1;
	float power = 0f;
	Sequence tween;
	// Start is called before the first frame update
	void Start()
	{
		powerId = Shader.PropertyToID("_Power");
		tween = DOTween.Sequence();
		tween.Append(DOTween.To(() => power, value =>
		{
			power = value;
			material.SetFloat(powerId, value);
		}, 20f, 2f)).SetEase(Ease.OutCubic);
		tween.Append(DOTween.To(() => power, value =>
		{
			power = value;
			material.SetFloat(powerId, value);
		}, 0f, 2f)).SetEase(Ease.OutCubic);
		tween.SetAutoKill(false);
		tween.Pause();
	}

	// Update is called once per frame
	void Update()
	{
		if (Input.GetKeyDown(KeyCode.Space))
			tween.Restart();
	}
}
