using UnityEditor;

namespace Sample
{
#if UNITY_EDITOR
	[CustomEditor(typeof(Blur), true)]
	public class BlurInspector : Editor
	{
		public override void OnInspectorGUI()
		{
			serializedObject.UpdateIfRequiredOrScript();
			var iterator = serializedObject.GetIterator();
			for (var enterChildren = true; iterator.NextVisible(enterChildren); enterChildren = false)
			{
				if (iterator.propertyPath == "materials")
					continue;
				using (new EditorGUI.DisabledScope(iterator.propertyPath == "m_Script"))
					EditorGUILayout.PropertyField(iterator, true);
			}
			serializedObject.ApplyModifiedProperties();
		}
	}

	[CustomEditor(typeof(DepthOfField), true)]
	public class DepthOfFieldInspector : BlurInspector
	{
	}
#endif
}
