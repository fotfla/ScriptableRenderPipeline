using System;
using UnityEngine;
using UnityEngine.Rendering;

namespace UnityEngine.Rendering.HighDefinition
{
    [Serializable,VolumeComponentMenu("CustomEffect/Distortion")]
    public sealed class Distortion : VolumeComponent, IPostProcessComponent
    {
        public ClampedFloatParameter amount = new ClampedFloatParameter(0f,0f,1f);
        public bool IsActive(){
            return amount.value > 0f;
        }   
    }
}
