using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using System.Linq;
using System;

public struct ZeroCrossing
{
    public double time;
    public int direction;

    public ZeroCrossing(int dir)
    {
        time = AudioSettings.dspTime;
        direction = dir;
    }
}
[RequireComponent(typeof(AudioSource))]
public class BinauralOscillator : MonoBehaviour
{

    [Range(30f, 1000f)]
    public float frequency = 220f;

    [Range(4f, 30f)]
    public float brainwave = 30f;

    [Range(0f, 1f)]
    public float amplitude = 0.6f;

    public float frequencyMin = 110f;

    private bool useBrainWaveStateVar = false;

    private float phaseL = 0f;
    private float phaseR = 0f;


    private float pi2 = Mathf.PI * 2f;
    private bool zeroL = false;
    private int zerosAlign = 0;
    private List<ZeroCrossing> zerosL;
    private List<ZeroCrossing> zerosR;
    private float zL = 0.0f;
    private float zR = 0.0f;

    private List<float> audioRange;

    [Range(0f, 2f)]
    public float _intensity = 0.5f;
    private SinusWave sinAAudio;
    private SinusWave sinBAudio;

    //

    private double sampleRate;  // samples per second
                                //private double myDspTime;	// dsp time
    private double dataLen;     // the data length of each channel
    double chunkTime;
    double dspTimeStep;
    double currentDspTime;


    public void Intensity(float val)
    {
        // TODO: Add more nuance to sound.
        //Debug.Log(val);
        _intensity = val;
        amplitude = Mathf.Lerp(0.01f, 0.9f, Mathf.Pow(_intensity, 1.5f));
        if (!useBrainWaveStateVar)
        {
            brainwave = Mathf.Lerp(20f, 3.9f, _intensity);
        }
        //frequency = Mathf.Lerp(330f, Mathf.Max(frequencyMin, 90f), _intensity);
    }

    public void BrainwaveFrequency(float val)
    {
        useBrainWaveStateVar = true;
        brainwave = val;
    }


    private void Awake()
    {
        audioRange = new List<float>();
        //InvokeRepeating("LogFrequency", 1f, 1f); // Repeated logging at 1sec interval.
        zerosL = new List<ZeroCrossing>();
        zerosR = new List<ZeroCrossing>();
        sinAAudio = new SinusWave();
        sinBAudio = new SinusWave();
        sampleRate = AudioSettings.outputSampleRate;
    }

    /*private void LogFrequency ()
    {
        Debug.Log("zeroL: " + zerosL.Count + "\t zeroR: " + zerosR.Count + "\t aligned:" + zerosAlign);
        ZeroCrossing l = zerosL.Last<ZeroCrossing>();
        ZeroCrossing r = zerosR.Last<ZeroCrossing>();
        zerosL.Clear();
        zerosR.Clear();
        zerosL.Add(l);
        zerosR.Add(r);  
        zerosAlign = 0;
    }
    */

    // Update is called once per frame
    //void Update()
    //{
    //    // Debug.Log("avg : " + audioRange.Average() + " | max: " + audioRange.Max() + " | min: " + audioRange.Min());
    //}

    private void OnAudioFilterRead(float[] data, int channels)
    {
        currentDspTime = AudioSettings.dspTime;
        dataLen = data.Length / channels;
        chunkTime = dataLen / sampleRate;
        dspTimeStep = chunkTime / dataLen;

        double preciseDspTime;
        double f = (double)frequency;
        double bf = f + (double)brainwave;
        for (int i = 0; i < dataLen; i++)
        {
            preciseDspTime = currentDspTime + i * dspTimeStep;
            double signalValueA = 0.0;
            double signalValueB = 0.0;
            double stepPercentage = (double)i / dataLen;
            signalValueA = sinAAudio.calculateSignalValue(preciseDspTime, f, (double)amplitude, stepPercentage);
            signalValueB = (double)amplitude * sinBAudio.calculateSignalValue(preciseDspTime, bf, (double)amplitude, stepPercentage);
            data[i * channels] = (float)signalValueA;
            data[i * channels + 1] = (float)signalValueB;
        }
    }
}
