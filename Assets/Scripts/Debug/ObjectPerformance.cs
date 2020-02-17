using UnityEngine;
//using HoloToolkit.Unity.SpatialMapping;

public class ObjectPerformance : MonoBehaviour
{

    //Create an array to hold any number of objects you want
    public GameObject[] objectArray = new GameObject[10]; //initialize the array for e.g. 10 cubes

    //Holds the index of the objectArray, which corresponds to the next object to be activated
    private int activateNext = 0;

    void Start()
    {

        for (int i = 1; i < objectArray.Length; i++)
        {
            objectArray[i].SetActive(false);
        }
        objectArray[0].SetActive(true);

    }
    
    void Update()
    {

        //whenever a click occurs, and as long as activateNext is less than the length of the array...
        
        if (Input.GetKeyDown(KeyCode.B)) // && activateNext < objectArray.Length)
        {
            Invoke("backObject", 2);
        }
        if (Input.GetKeyDown(KeyCode.N)) // && activateNext < objectArray.Length)
        {
           Invoke("nextObject", 2);
        }
        
    }

  public void nextObject()
    {
        //... activate next object
        activateNext++;
        if (activateNext > objectArray.Length - 1) activateNext = 0;
        objectArray[activateNext].SetActive(true);
        if (activateNext > 0) objectArray[activateNext - 1].SetActive(false);
        if (activateNext == 0) objectArray[objectArray.Length - 1].SetActive(false);
        
    }

    public void backObject()
    {
        //... activate next cube
        activateNext--;
        if (activateNext < 0) activateNext = objectArray.Length - 1;
        objectArray[activateNext].SetActive(true);
        if (activateNext < objectArray.Length - 1) objectArray[activateNext + 1].SetActive(false);
        if (activateNext == objectArray.Length - 1) objectArray[0].SetActive(false);
    }




}