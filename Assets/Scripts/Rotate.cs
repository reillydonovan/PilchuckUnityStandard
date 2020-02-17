using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float xSpeed = 1.0f;
    public float ySpeed = 1.0f;
    public float zSpeed = 1.0f;
    void Update()
	{
		// Rotate the object around its local X axis at 1 degree per second
		transform.Rotate(Time.deltaTime * xSpeed, Time.deltaTime * ySpeed, Time.deltaTime * zSpeed);

		// ...also rotate around the World's Y axis
	//transform.Rotate(Vector3.up * Time.deltaTime, Space.World);
	}
}