//-----------------------------------------------------------------------
// <copyright file="Chimer.cs" company="IDIA Lab">
//     Copyright (c) IDIA Lab. All rights reserved.
// </copyright>
// <summary>This is the Chimer component. Attach to a GameObject and it will translate a scene's WindZone to physics force.</summary>
//-----------------------------------------------------------------------
namespace IDIA.ATK.Demo
{
    using System.Collections;
    using UnityEngine;

    /// <summary>
    /// The Chimer component.
    /// Attach to a GameObject and it will translate a scene's WindZone to physics force.
    /// </summary>
    public class Chimer : MonoBehaviour
    {
        #region Fields
        /// <summary>
        /// The WindZone.
        /// </summary>
        private WindZone windZone;

        /// <summary>
        /// The <see cref="Rigidbody"/>.
        /// </summary>
        private Rigidbody rb;

        /// <summary>
        /// The direction the wind is blowing.
        /// </summary>
        private Vector3 direction;

        /// <summary>
        /// The strength of the wind.
        /// </summary>
        [SerializeField]
        private float strength;
        #endregion

        #region Properties
        /// <summary>
        /// Gets or sets the strength of the wind.
        /// </summary>
        public float Strength
        {
            get
            {
                return this.strength;
            }

            set
            {
                this.strength = value;
            }
        }
        #endregion

        #region Methods
        /// <summary>
        /// Start is called on the frame when a script is enabled just before any of the Update methods are called the first time.
        /// </summary>
        private void Start()
        {
            this.windZone = GameObject.FindObjectOfType<WindZone>();
            this.rb = this.GetComponent<Rigidbody>();
            this.StartCoroutine(this.UpdateDirection());
        }

        /// <summary>
        /// UpdateDirection is a <see cref="Coroutine"/> that updates the direction that force should be applied based on the wind direction.
        /// </summary>
        /// <returns>The IEnumerator.</returns>
        private IEnumerator UpdateDirection()
        {
            this.direction = this.windZone.transform.forward * ((Random.value * this.windZone.windTurbulence) - this.windZone.windPulseMagnitude);
            yield return new WaitForSeconds(this.windZone.windPulseFrequency);
            this.StartCoroutine(this.UpdateDirection());
        }

        /// <summary>
        /// Frame-rate independent <see cref="MonoBehaviour"/>.FixedUpdate message for physics calculations.
        /// </summary>
        private void FixedUpdate()
        {
            Vector3 force = this.direction * this.windZone.windMain * this.strength;
            this.rb.AddForce(force, ForceMode.Acceleration);
        }
        #endregion
    }
}