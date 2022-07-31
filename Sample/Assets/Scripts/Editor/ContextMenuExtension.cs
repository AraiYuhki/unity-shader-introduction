using System;
using System.IO;
using UnityEditor;

namespace Sample
{
	public static class ContextMenuExtension
	{
		[MenuItem("Assets/Create/Shader/Library")]
		private static void CreateShaderLibrary()
		{
			var path = AssetDatabase.GetAssetPath(Selection.activeInstanceID);
			var fullPath = Path.GetFullPath(path);
			if (!File.GetAttributes(fullPath).HasFlag(FileAttributes.Directory))
				throw new Exception($"{fullPath} is not directory");
			var filePath = Path.Combine(fullPath, "NewShaderLibrary.cginc");
			File.Create(filePath);
		}
	}
}
