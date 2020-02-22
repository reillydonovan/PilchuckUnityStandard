//-----------------------------------------------------------------------
// <copyright file="Rotator.cs" company="IDIA Lab">
//     Copyright (c) IDIA Lab. All rights reserved.
// </copyright>
// <summary>This is the Rotator component. Attach to a GameObject to make it rotate.</summary>
//-----------------------------------------------------------------------
namespace IDIA.ATK.Demo
{
    using UnityEngine;

    /// <summary>
    /// The Rotator component. 
    /// Attach to a GameObject to make it rotate.
    /// </summary>
    public class Rotator : MonoBehaviour
    {
        #region Fields
        /// <summary>
        /// The rotation speed.
        /// </summary>
        [SerializeField]
        private float rotationSpeed;
        #endregion

        #region Properties
        /// <summary>
        /// Gets or sets the rotation speed.
        /// </summary>
        public float RotationSpeed
        {
            get
            {
                return this.rotationSpeed;
            }

            set
            {
                this.rotationSpeed = value;
            }
        }
        #endregion

        #region Methods
        /// <summary>
        /// Frame-rate independent <see cref="MonoBehaviour"/>.FixedUpdate message for physics calculations.
        /// </summary>
        private void FixedUpdate()
        {
            transform.Rotate(transform.up, this.RotationSpeed * Time.deltaTime);
        } 
        #endregion
    }
}