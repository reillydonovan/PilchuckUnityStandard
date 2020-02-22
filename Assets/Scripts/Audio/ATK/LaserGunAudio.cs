using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ATKSharp.Generators.Oscillators.Trivial;
using ATKSharp.Envelopes;
using ATKSharp.Modifiers;

[RequireComponent(typeof(AudioSource))]
public class LaserGunAudio : MonoBehaviour
{
    [SerializeField]
    float frequency = 1000f;
    [SerializeField]
    float frequencyDrop = 200f;
    [SerializeField]
    float frequencyDropSpeed = 20f;
    TPhasor phasor;
    CTEnvelope envelope;
    float amplitude = .7f;
    LowPass lowPass;

    Coroutine shootCoroutine;

    void Start()
    {
        phasor = new TPhasor();
        envelope = new CTEnvelope();
        lowPass = new LowPass();
    }
    private void Update()
    {

        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (shootCoroutine != null)
                StopCoroutine(shootCoroutine);
            shootCoroutine = StartCoroutine(Shoot());
        }
        //envelope.Gate = Input.GetKey(KeyCode.Space) ? 1 : 0;
    }

    IEnumerator Shoot()
    {
        envelope.Gate = 1;
        float adjustedFrequency = frequency;
        while(adjustedFrequency > frequency - frequencyDrop)
        {
            adjustedFrequency -= frequencyDropSpeed;
            phasor.Frequency = adjustedFrequency;
            yield return new WaitForEndOfFrame();
        }
        envelope.Gate = 0;
    }

    private void OnAudioFilterRead(float[] data, int channels)
    {
        if (phasor == null) return;
        for (int i = 0; i < data.Length; i+= channels)
        {
            float currentSample = phasor.Generate() * envelope.Generate();
            currentSample = lowPass.Modify(currentSample);
            for(int j = 0; j < channels; j++)
            {
                data[i + j] = currentSample;
            }
        }
    }
}
