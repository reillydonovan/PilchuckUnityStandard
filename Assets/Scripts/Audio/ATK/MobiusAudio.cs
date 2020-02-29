//-----------------------------------------------------------------------
// <copyright file="CricketAudio.cs" company="IDIA Lab">
//     Copyright (c) IDIA Lab. All rights reserved.
// </copyright>
// <summary>This is the CricketAudio component. Attach to a GameObject and hear a cricket.</summary>
//-----------------------------------------------------------------------
namespace IDIA.ATK.Audio
{
    using System.Collections;
    using ATKSharp.Envelopes;
    using ATKSharp.Generators.Oscillators.Trivial;
    using ATKSharp.Generators.Oscillators.Wavetable;
    using UnityEngine;

    /// <summary>
    /// The CricketAudio component.
    /// Attach to a GameObject and hear a cricket.
    /// </summary>
    [RequireComponent(typeof(AudioSource))]
    public class MobiusAudio : MonoBehaviour
    {
        #region Fields
        /// <summary>
        /// The center frequency of the chirp.
        /// </summary>
        [Header("Chirp")]
        [Range(0f, 20000f)]
        [SerializeField]
        private float centerFrequency = 3259f;

        /// <summary>
        /// The frequency spread of the chirp.
        /// </summary>
        [SerializeField]
        private float frequencySpread = .07f;

        /// <summary>
        /// The duration of the chirp.
        /// </summary>
        [SerializeField]
        private float chirpDuration = .140f;

        /// <summary>
        /// The gap duration between each chirp.
        /// </summary>
        [SerializeField]
        private float chirpGap = .020f;

        /// <summary>
        /// The duration of a pause.
        /// </summary>
        [Range(0f, 10f)]
        [SerializeField]
        private float chirpPause = 5f;

        /// <summary>
        /// The chance that a cricket will pause chirping.
        /// </summary>
        [Range(0f, 1f)]
        [SerializeField]
        private float chirpPauseChance = .1f;

        /// <summary>
        /// The number of pulses in a chirp.
        /// </summary>
        [SerializeField]
        private int chirpPulses = 4;

        /// <summary>
        /// The number of chirps per second.
        /// </summary>
        [SerializeField]
        private float chirpsPerSecond = 2;

        /// <summary>
        /// The amplitude of a chirp.
        /// </summary>
        [Range(0f, 1f)]
        [SerializeField]
        private float chirpAmplitude = 1f;

        /// <summary>
        /// The control <see cref="TPhasor"/> wave generator.
        /// </summary>
        private TPhasor control;

        /// <summary>
        /// The fundamental <see cref="WTSine"/> wave generator.
        /// </summary>
        private WTSine fundamental;

        /// <summary>
        /// The octave <see cref="WTSine"/> wave generator.
        /// </summary>
        private WTSine octave;

        /// <summary>
        /// The modulator <see cref="WTSine"/> wave generator.
        /// </summary>
        private WTSine modulator;

        /// <summary>
        /// The chirp envelope.
        /// </summary>
        private CTEnvelope chirpEnvelope;
        #endregion

        #region Properties
        /// <summary>
        /// Gets or sets the center frequency of the chirp.
        /// </summary>
        public float CenterFrequency
        {
            get
            {
                return this.centerFrequency;
            }

            set
            {
                if (value >= 0 && value <= 20000)
                {
                    this.centerFrequency = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the frequency spread of the chirp.
        /// </summary>
        public float FrequencySpread
        {
            get
            {
                return this.frequencySpread;
            }

            set
            {
                this.frequencySpread = value;
            }
        }

        /// <summary>
        /// Gets or sets the duration of the chirp.
        /// </summary>
        public float ChirpDuration
        {
            get
            {
                return this.chirpDuration;
            }

            set
            {
                this.chirpDuration = value;
            }
        }

        /// <summary>
        /// Gets or sets the gap duration between each chirp.
        /// </summary>
        public float ChirpGap
        {
            get
            {
                return this.chirpGap;
            }

            set
            {
                this.chirpGap = value;
            }
        }

        /// <summary>
        /// Gets or sets the duration of a pause.
        /// </summary>
        public float ChirpPause
        {
            get
            {
                return this.chirpPause;
            }

            set
            {
                if (value >= 5f && value <= 10f)
                {
                    this.chirpPause = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the chance that a cricket will pause chirping.
        /// </summary>
        public float ChirpPauseChance
        {
            get
            {
                return this.chirpPauseChance;
            }

            set
            {
                if (value >= 0f && value <= 1f)
                {
                    this.chirpPauseChance = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the number of pulses in a chirp.
        /// </summary>
        public int ChirpPulses
        {
            get
            {
                return this.chirpPulses;
            }

            set
            {
                this.chirpPulses = value;
            }
        }

        /// <summary>
        /// Gets or sets the number of chirps per second.
        /// </summary>
        public float ChirpsPerSecond
        {
            get
            {
                return this.chirpsPerSecond;
            }

            set
            {
                this.chirpsPerSecond = value;
            }
        }

        /// <summary>
        /// Gets or sets the amplitude of a chirp.
        /// </summary>
        public float ChirpAmplitude
        {
            get
            {
                return this.chirpAmplitude;
            }

            set
            {
                if (value >= 0f && value <= 1f)
                {
                    this.chirpAmplitude = value;
                }
            }
        }
        #endregion

        #region Methods
        /// <summary>
        /// Awake is called when the script instance is being loaded.
        /// </summary>
        private void Awake()
        {
            Application.runInBackground = true;
        }

        /// <summary>
        /// Start is called on the frame when a script is enabled just before any of the Update methods are called the first time.
        /// </summary>
        private void Start()
        {
            this.control = new TPhasor(1 / this.ChirpDuration);
            this.fundamental = new WTSine(this.CenterFrequency);
            this.octave = new WTSine(this.CenterFrequency * .5f);
            this.modulator = new WTSine(this.CenterFrequency * 2f);
            this.chirpEnvelope = new CTEnvelope(20, 0, .7f, 130);
            this.StartCoroutine(this.Chirp());
        }

        /// <summary>
        /// Update is called every frame, if the <see cref="MonoBehaviour"/> is enabled.
        /// </summary>
        private void Update()
        {
            this.fundamental.Frequency = this.CenterFrequency;
        }

        /// <summary>
        /// Chirp is a recursive <see cref="Coroutine"/> that opens and closes the <see cref="chirpEnvelope"/>'s gate when called.
        /// It also determines whether to take a pause from chirping based on <see cref="chirpPauseChance"/>.
        /// </summary>
        /// <returns>The IEnumerator.</returns>
        private IEnumerator Chirp()
        {
            for (int i = 0; i < this.ChirpPulses; i++)
            {
                this.chirpEnvelope.Gate = 1;
                yield return new WaitForSeconds(this.ChirpDuration);
                this.chirpEnvelope.Gate = 0;
                yield return new WaitForSeconds(this.ChirpGap);
            }

            yield return new WaitForSeconds(1 / this.ChirpsPerSecond);
            if (Random.value < this.ChirpPauseChance)
            {
                yield return new WaitForSeconds(this.ChirpPause);
            }

            this.StartCoroutine(this.Chirp());
        }

        /// <summary>
        /// OnAudioFilterRead is called every time a chunk of audio is sent to the filter.
        /// </summary>
        /// <param name="data">An array of floats comprising the audio data.</param>
        /// <param name="channels">An <see cref="System.Int32"/> that stores the number of channels of audio data passed to this delegate.</param>
        private void OnAudioFilterRead(float[] data, int channels)
        {
            for (int i = 0; i < data.Length; i += channels)
            {
                EnvelopeState lastEnvelopeState = this.chirpEnvelope.State;
                if (this.chirpEnvelope.State != lastEnvelopeState && this.chirpEnvelope.State == EnvelopeState.ATTACK)
                {
                    this.control.Phase = 0;
                }

                float controlFrequency = 1 - (this.control.Generate() * this.FrequencySpread);
                this.fundamental.Frequency = this.CenterFrequency * controlFrequency;
                this.octave.Frequency = this.fundamental.Frequency * 2;
                this.octave.Amplitude = .3f;
                this.modulator.Frequency = controlFrequency * 40.6f;
                this.modulator.Generate();
                float modulatorSquared = this.modulator.CurrentSample * this.modulator.CurrentSample;
                float rawSample = modulatorSquared * (this.fundamental.Generate() + this.octave.Generate());
                float currentSample = this.chirpEnvelope.Generate() * rawSample * this.ChirpAmplitude;
                for (int j = 0; j < channels; j++)
                {
                    data[i + j] = currentSample;
                }
            }
        }
        #endregion
    }
}