using UnityEngine;

namespace Sample
{
	[RequireComponent(typeof(Camera))]
	public class HorizontalCameraRotater : MonoBehaviour
	{
		[SerializeField]
		private Quaternion rotate = Quaternion.identity;
		private float length = 0f;

		private float angle = 0f;
		const float MoveAngle = 0.2f;

		// Start is called before the first frame update
		void Start()
		{
			length = transform.position.magnitude;
			rotate = Quaternion.AngleAxis(180f, Vector3.up);
		}

		// Update is called once per frame
		void Update()
		{
			rotate *= Quaternion.AngleAxis(MoveAngle, Vector3.up);
			angle += MoveAngle;
			var position = rotate * (Vector3.forward * length);
			position.y = 2.0f;
			transform.position = position;

			Camera.main.transform.LookAt(Vector3.up);
		}
	}
}
