using System;
using UnityEngine;
using UnityEngine.Rendering;

namespace UnityEngine.Rendering.HighDefinition
{
    [Serializable,VolumeComponentMenu("CustomEffect/Glitch01")]
    public sealed class Glitch01 : VolumeComponent, IPostProcessComponent
    {
        public ClampedFloatParameter amount = new ClampedFloatParameter(0f,0f,1f);
        public Vector2Parameter resolution = new Vector2Parameter(new Vector2(8, 16));
        public  ClampedFloatParameter threshold = new ClampedFloatParameter(0f,0,1);
        public  IntParameter seed = new IntParameter(0);

        public bool IsActive(){
            return amount.value > 0f;
        }
    }
}
