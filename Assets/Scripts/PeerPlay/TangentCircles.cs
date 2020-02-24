using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TangentCircles : CircleTangent
{
    public GameObject circlePrefab;
    private GameObject innerCircleGO, outterCircleGO;
    public Vector4 innerCircle, outterCircle;
    private Vector4[] tangentCircle;
    private GameObject[] tangentObject;

    [Range(1,64)]
    public int circleAmount;

    // Start is called before the first frame update
    void Start()
    {
        innerCircleGO = (GameObject)Instantiate(circlePrefab);
        outterCircleGO = (GameObject)Instantiate(circlePrefab);
        tangentCircle = new Vector4[circleAmount];
        tangentObject = new GameObject[circleAmount];

        for(int i = 0; i < circleAmount; i++)
        {
            GameObject tangentInstance = (GameObject)Instantiate(circlePrefab);
            tangentObject[i] = tangentInstance;
            tangentObject[i].transform.parent = this.transform;
        }
    }

    // Update is called once per frame
    void Update()
    {
        innerCircleGO.transform.position = new Vector3(innerCircle.x, innerCircle.y, innerCircle.z);
        innerCircleGO.transform.localScale = new Vector3(innerCircle.w, innerCircle.w, innerCircle.w) * 2;
        outterCircleGO.transform.position = new Vector3(outterCircle.x, outterCircle.y, outterCircle.z);
        outterCircleGO.transform.localScale = new Vector3(outterCircle.w, outterCircle.w, outterCircle.w) * 2;

        for (int i = 0; i < circleAmount; i++)
        {
            tangentCircle[i] = FindTangentCircle(outterCircle, innerCircle, (360f / circleAmount) * i);
            tangentObject[i].transform.position = new Vector3(tangentCircle[i].x, tangentCircle[i].y, tangentCircle[i].z);
            tangentObject[i].transform.localScale = new Vector3(tangentCircle[i].w, tangentCircle[i].w, tangentCircle[i].w) * 2;
        }
    }
}
