using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum BrainwaveState
{
    None,     // 0hz
    Gamma,    // 40hz   intensity: 0.00 - 0.15 range 0.15
    Beta,     // 18hz   intensity: 0.15 - 0.35 range 0.20
    Alpha,    // 10hz   intensity: 0.35 - 0.65 range 0.30
    Theta,    // 5.1hz  intensity: 0.65 - 0.85 range 0.20
    Delta,    // 2.5hz  intensity: 0.85 - 1.00 range 0.15
}

public class IntensityManager : MonoBehaviour
{
    public bool use_head_transform = true;
    public BrainwaveState currentBrainwavePattern = BrainwaveState.Gamma;
    [Range(0f, 1f)]
    public float intensity = 0.01f;
    [Range(-1f, 1f)]
    public float intensityDirection = 0f; // whether intensity is increasing -1, 1
    private float targetIntensity = 0.01f; // Start in low

    // proximity score may help increase the intensity
    // but probably should not detract from the intensity
    public float proximityScore = 0f;




    public BinauralOscillator binauralSouce;
    public GameObject focusObject;
    public GameObject cameraObject;

    public float distanceCameraToObject;
    private float falloffDistance;

    private List<float> accumOffsetsFalloff;
    private List<float> accumOffsetsCameraRot;
    private List<float> accumOffsetsCameraPos;
    private Vector3 lastPosition;
    private Quaternion lastRotation;

    public float frequencyForBrainwaveState(BrainwaveState bwState)
    {
        if (bwState == BrainwaveState.Gamma) { return 40f; }
        if (bwState == BrainwaveState.Beta) { return 18f; }
        if (bwState == BrainwaveState.Alpha) { return 10f; }
        if (bwState == BrainwaveState.Theta) { return 5.1f; }
        //if (bwState == BrainwaveState.Delta) { return 2.5f; }
        return 2.5f;
    }
    // Start is called before the first frame update
    void Start()
    {
        if (cameraObject == null) cameraObject = GameObject.FindGameObjectWithTag("MainCamera");
        if (cameraObject == null) { Debug.LogError("I'm sorry Dave, we could not find your view."); Debug.Break(); }
        if (binauralSouce == null) { Debug.LogError("no binaural source mapped."); Debug.Break(); }
        lastPosition = cameraObject.transform.position;
        lastRotation = cameraObject.transform.rotation;
        accumOffsetsCameraPos = new List<float>();
        accumOffsetsCameraRot = new List<float>();
    }

    // Update Intensity on every frame
    void Update()
    {
        if (!use_head_transform)
        {
            binauralSouce.Intensity(intensity);
            return;
        }
        //TODO: Calculate a penalty for too much looking around/moving

        // after movement is calculated store in "last" params.
        lastPosition = cameraObject.transform.position;
        lastRotation = cameraObject.transform.rotation;
        //---------------------------------------------

        distanceCameraToObject = Vector3.Distance(cameraObject.transform.position, focusObject.transform.position);
        //TODO: Generate a proximity score based on distanceCameraToObject
        //      What is a distance that 

        // Calculate look vector falloff from center of the focus object.
        this.transform.position = cameraObject.transform.TransformPoint(Vector3.forward * distanceCameraToObject);
        falloffDistance = Vector3.Distance(this.transform.position, focusObject.transform.position);
        falloffDistance = Mathf.Sqrt((2f - (falloffDistance / (distanceCameraToObject + Mathf.Epsilon))) * 0.5f);
        // Combine factors into a target intensity
        float oldTarget = targetIntensity;

        //TODO: calculate a target from addtional factors besides just the falloff distance
        targetIntensity = falloffDistance;
        //TODO: include proximity delta into calculation
        //      proximity less than the radius of the entity should be an automatic 1.0


        //TODO: include hand collision bump





        intensityDirection = targetIntensity - oldTarget;
        float intensityLerp = (targetIntensity > oldTarget) ? .010f : .040f;
        //TODO: LERP the intensity ramp over more time.
        //TODO: Maybe the Lerp ramps should be isolated to the classes that take the intensity as input.
        intensity = Mathf.Lerp(oldTarget, targetIntensity, intensityLerp);
        BrainwaveState potentialState = currentBrainwavePattern;
        float thresholdMax, thresholdMin;
        switch (currentBrainwavePattern)
        {
            case BrainwaveState.Gamma:
                thresholdMax = 0.15f + 0.03f;
                if (intensity > thresholdMax)
                    potentialState = BrainwaveState.Beta;
                break;
            case BrainwaveState.Beta:
                thresholdMin = 0.15f - 0.03f;
                thresholdMax = 0.35f + 0.03f;
                if (intensity < thresholdMin) potentialState = BrainwaveState.Gamma;
                if (intensity > thresholdMax) potentialState = BrainwaveState.Alpha;
                break;
            case BrainwaveState.Alpha:
                thresholdMin = 0.35f - 0.03f;
                thresholdMax = 0.65f + 0.03f;
                if (intensity < thresholdMin) potentialState = BrainwaveState.Beta;
                if (intensity > thresholdMax) potentialState = BrainwaveState.Theta;
                break;
            case BrainwaveState.Theta:
                thresholdMin = 0.65f - 0.03f;
                thresholdMax = 0.85f + 0.03f;
                if (intensity < thresholdMin) potentialState = BrainwaveState.Alpha;
                if (intensity > thresholdMax) potentialState = BrainwaveState.Delta;
                break;
            case BrainwaveState.Delta:
                thresholdMin = 0.85f - 0.03f;
                if (intensity < thresholdMin) potentialState = BrainwaveState.Theta;
                break;
            default:
                Debug.Log("BrainwaveState not accounted.");
                break;
        }
        currentBrainwavePattern = potentialState;


        // Send Intensity value to BinauralGenerator
        binauralSouce.Intensity(intensity);
        binauralSouce.BrainwaveFrequency(frequencyForBrainwaveState(currentBrainwavePattern));


    }

}
