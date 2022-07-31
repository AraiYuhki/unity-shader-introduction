using System;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace Sample
{
    public class NoiseTextureGenerator : EditorWindow
    {
        private static Texture2D result;
        private static int width = 100;
        private static int height = 100;
        private static Vector2 offset = Vector2.zero;
        private static Vector2 scale = Vector2.one;

        [MenuItem("Tools/パーリンノイズ生成機")]
        public static void Open()
        {
            GetWindow<NoiseTextureGenerator>();
        }

        public void OnGUI()
        {
            using (new EditorGUILayout.VerticalScope())
            {
                using (new EditorGUILayout.HorizontalScope())
                {
                    width = EditorGUILayout.IntField("幅", width);
                    height = EditorGUILayout.IntField("高さ", height);
                    width = Mathf.Max(1, width);
                    height = Mathf.Max(1, height);
                }
                using (new EditorGUILayout.HorizontalScope())
                {
                    offset = EditorGUILayout.Vector2Field("オフセット", offset);
                    scale = EditorGUILayout.Vector2Field("スケール", scale);
                }
            }
            using (new EditorGUILayout.HorizontalScope())
            {
                if (GUILayout.Button("生成"))
                    Generate();
                using (new EditorGUI.DisabledScope(result == null))
                {
                    if (GUILayout.Button("クリア"))
                    {
                        DestroyImmediate(result);
                        result = null;
                    }
                    if (GUILayout.Button("保存"))
                        Save();
                }
            }
            if (result != null)
            {
                EditorGUILayout.LabelField(new GUIContent(result), GUILayout.Width(result.width), GUILayout.Height(result.height));
            }
        }

        private void Save()
        {
            var path = EditorUtility.SaveFilePanel("保存", Application.dataPath, "PerlingNoise.png", "png");
            if (string.IsNullOrEmpty(path)) return;
            using (var sw = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.Read))
            using (var bw = new BinaryWriter(sw))
            {
                bw.Write(result.EncodeToPNG());
            }
            path = path.Replace(Application.dataPath, "Assets/");
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);
            var importer = AssetImporter.GetAtPath(path) as TextureImporter;
            if (importer == null) return;
            importer.isReadable = true;
            importer.SaveAndReimport();
        }

        private void Generate()
        {
            var seed = UnityEngine.Random.Range(-1000f, 1000f);
            if (result != null) DestroyImmediate(result);
            result = new Texture2D(width, height, TextureFormat.ARGB32, false);
            for (var x = 0; x < width; x++)
            {
                for (var y = 0; y < height; y++)
                {
                    var value = Mathf.PerlinNoise(seed + offset.x + x / (float)result.width * scale.x, seed + offset.y + y / (float)result.height * scale.y);
                    result.SetPixel(x, y, new Color(value, value, value, 1f));
                }
            }
            result.Apply();
        }
    }
}
