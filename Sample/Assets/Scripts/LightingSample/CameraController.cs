using UnityEngine;

namespace Sample
{
	[RequireComponent(typeof(Camera))]
	public class CameraController : MonoBehaviour
	{
		[SerializeField]
		private Quaternion rotate = Quaternion.identity;
		private float length = 0f;

		private float angle = 0f;
		bool rotateHorizontal = true;
		const float MoveAngle = 0.6f;

		// Start is called before the first frame update
		void Start()
		{
			length = transform.position.magnitude;
			rotate = Quaternion.AngleAxis(180f, Vector3.up);
		}

		// Update is called once per frame
		void Update()
		{
			rotate *= rotateHorizontal ? Quaternion.AngleAxis(MoveAngle, Vector3.up) : Quaternion.AngleAxis(MoveAngle, new Vector3(1f, 1f, 0).normalized);
			angle += MoveAngle;
			if (angle >= 360f)
			{
				rotateHorizontal = !rotateHorizontal;
				angle = 0f;
			}
			transform.position = rotate * (Vector3.forward * length);
			Camera.main.transform.LookAt(Vector3.zero);
		}
	}
}
