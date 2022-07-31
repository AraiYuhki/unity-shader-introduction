using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;
using System.IO;

namespace Sample
{
    public class TextureMergeTool : EditorWindow
    {
        private static Texture2D redChannel = null;
        private static Texture2D greenChannel = null;
        private static Texture2D blueChannel = null;
        private static Texture2D alphaChannel = null;
        private static Texture2D result = null;

        [MenuItem("Tools/テクスチャ合成機")]
        public static void Open()
        {
            GetWindow<TextureMergeTool>();
        }

        public void OnGUI()
        {
            EditorGUI.BeginChangeCheck();
            redChannel = EditorGUILayout.ObjectField("赤", redChannel, typeof(Texture2D), true) as Texture2D;
            greenChannel = EditorGUILayout.ObjectField("緑", greenChannel, typeof(Texture2D), true) as Texture2D;
            blueChannel = EditorGUILayout.ObjectField("青", blueChannel, typeof(Texture2D), true) as Texture2D;
            alphaChannel = EditorGUILayout.ObjectField("α", alphaChannel, typeof(Texture2D), true) as Texture2D;
            if (EditorGUI.EndChangeCheck())
            {
                UpdateResult();
            }
            using (new EditorGUI.DisabledGroupScope(result == null))
            {
                if (GUILayout.Button("保存"))
                    Save();
            }
            if (result != null)
            {
                EditorGUILayout.LabelField(new GUIContent(result), GUILayout.Width(result.width), GUILayout.Height(result.height));
            }
        }

        private void Save()
        {
            var path = EditorUtility.SaveFilePanel("保存", Application.dataPath, "Texture.png", "png");
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

        private void UpdateResult()
        {
            var textureList = new Texture2D[] { redChannel, greenChannel, blueChannel, alphaChannel };
            var width = textureList.Where(texture => texture != null).Min(texture => texture.width);
            var height = textureList.Where(texture => texture != null).Min(texture => texture.height);
            if (result != null) DestroyImmediate(result);
            result = new Texture2D(width, height);
            for (var x = 0; x < width; x++)
            {
                for (var y = 0; y < height; y++)
                {
                    var red = redChannel != null ? redChannel.GetPixel(x, y).grayscale : 1f;
                    var green = greenChannel != null ? greenChannel.GetPixel(x, y).grayscale : 1f;
                    var blue = blueChannel != null ? blueChannel.GetPixel(x, y).grayscale : 1f;
                    var alpha = alphaChannel != null ? alphaChannel.GetPixel(x, y).grayscale : 1f;
                    result.SetPixel(x, y, new Color(red, green, blue, alpha));
                }
            }
            result.Apply();
        }
    }
}
