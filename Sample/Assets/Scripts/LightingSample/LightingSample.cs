using System.Linq;
using UnityEngine;

public class LightingSample : MonoBehaviour
{
	[SerializeField]
	private GameObject[] objectGroupList = new GameObject[0];
	[SerializeField]
	private int selectedIndex = 0;
	[SerializeField]
	private Light directionalLight;
	[SerializeField]
	private Color color = Color.white;
	[SerializeField]
	private Vector3 direction = new Vector3(50f, -30f, 0f);

	public void OnValidate()
	{
		selectedIndex = Mathf.Clamp(selectedIndex, 0, objectGroupList.Length - 1);
		foreach ((var group, var index) in objectGroupList.Select((group, index) => (group, index)))
			group.SetActive(selectedIndex == index);

		directionalLight.color = color;
		directionalLight.transform.rotation = Quaternion.Euler(direction);
	}
}
