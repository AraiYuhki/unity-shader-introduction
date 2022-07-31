using System;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

namespace Sample
{
	public class BlendModeCheck : MonoBehaviour
	{
		private static readonly BlendOp[] UsableBlendOpList = new[]
		{
		BlendOp.Add,
		BlendOp.Subtract,
		BlendOp.ReverseSubtract,
		BlendOp.Min,
		BlendOp.Max
	};

		[SerializeField]
		private Renderer target;
		[SerializeField]
		private TMP_Dropdown srcFactor;
		[SerializeField]
		private TMP_Dropdown dstFactor;
		[SerializeField]
		private TMP_Dropdown blendOp;

		private int srcFactorId = -1;
		private int dstFactorId = -1;
		private int blendOpId = -1;
		// Start is called before the first frame update
		void Start()
		{
			srcFactorId = Shader.PropertyToID("_SrcFactor");
			dstFactorId = Shader.PropertyToID("_DstFactor");
			blendOpId = Shader.PropertyToID("_BlendOp");
			srcFactor.options.Clear();
			dstFactor.options.Clear();
			blendOp.options = UsableBlendOpList.Select(blendOp => new TMP_Dropdown.OptionData(Enum.GetName(typeof(BlendOp), blendOp))).ToList();
			foreach (var name in Enum.GetNames(typeof(BlendMode)))
			{
				srcFactor.options.Add(new TMP_Dropdown.OptionData(name));
				dstFactor.options.Add(new TMP_Dropdown.OptionData(name));
			}
			srcFactor.value = (int)target.material.GetFloat(srcFactorId);
			dstFactor.value = (int)target.material.GetFloat(dstFactorId);
			blendOp.value = Array.IndexOf(UsableBlendOpList, (BlendOp)target.material.GetFloat(blendOpId));
		}

		public void OnChangeSrcFactor() => target.material.SetFloat(srcFactorId, srcFactor.value);
		public void OnChangeDstFactor() => target.material.SetFloat(dstFactorId, dstFactor.value);
		public void OnChangeBlendOp() => target.material.SetFloat(blendOpId, blendOp.value);
	}
}
