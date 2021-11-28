using System.Collections.Generic;
using UnityEngine;

public enum ShaderProperty
{
	Param = 0,
	VertexNum,
	Angle
}

public class ShaderUtil
{
	private static Dictionary<ShaderProperty, int> propertyIds = new Dictionary<ShaderProperty, int>()
	{
		{ ShaderProperty.Param, Shader.PropertyToID("_Param") },
		{ ShaderProperty.VertexNum, Shader.PropertyToID("_VertexNum") },
		{ ShaderProperty.Angle, Shader.PropertyToID("_Angle") }
	};

	public static int GetPropertyId(ShaderProperty key) => propertyIds.TryGetValue(key, out var id) ? id : -1;
}
