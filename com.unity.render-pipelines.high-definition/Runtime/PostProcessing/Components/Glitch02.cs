using System;
using UnityEngine;
using UnityEngine.Rendering;

namespace UnityEngine.Rendering.HighDefinition
{
    [Serializable,VolumeComponentMenu("CustomEffect/Glitch02")]
    public sealed class Glitch02 : VolumeComponent, IPostProcessComponent
    {
        public ClampedFloatParameter amount = new ClampedFloatParameter(0f,0f,1f);
        public IntParameter div = new IntParameter(9);
        public FloatParameter intensity = new FloatParameter(1);
        public IntParameter seed = new IntParameter(0);

        public bool IsActive(){
            return amount.value > 0f;
        }
    }
}
