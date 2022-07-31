using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

namespace Sample
{
	public class Posterization : PostEffect
	{
		[SerializeField]
		private float divideNum = 100f;
		[SerializeField]
		private Text label;

		[SerializeField]
		bool play = false;

		int divideNumId = -1;
		Tween tween;
		// Start is called before the first frame update
		void Start()
		{
			divideNumId = Shader.PropertyToID("_DivideNum");
			tween = DOTween.To(() => divideNum, value => divideNum = value, 0f, 30.0f);
			tween.Pause();
			tween.SetAutoKill(false);
		}

		// Update is called once per frame
		void Update()
		{
			if (Input.GetKeyDown(KeyCode.Space))
			{
				tween.Restart();
			}
			label.text = string.Format("DivideNum {0:0.00}", divideNum);
		}
		protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
		{
			material.SetFloat(divideNumId, divideNum);
			base.OnRenderImage(source, destination);
		}
	}
}
