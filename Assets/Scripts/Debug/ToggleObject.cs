using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleObject : MonoBehaviour {

    public GameObject toggleGameObject;
    bool toggle;

    void Start()
    {

        toggle = true;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.T)) // && activateNext < objectArray.Length)
        {
            ObjectToToggle();
        }
    }
    // Use this for initialization
    public void ObjectToToggle () {
        toggle = !toggle;
        toggleGameObject.SetActive(toggle);
     		
	}

    public void ToggleOn()
    {
        toggleGameObject.SetActive(true);
    }

    public void ToggleOff()
    {
        toggleGameObject.SetActive(false);
    }
}
