using System.Collections.Generic;

namespace UnityEngine.Experimental.VoxelizedShadows
{
    [ExecuteAlways]
    [AddComponentMenu("Rendering/VxShadowMaps/PointVxShadowMap", 110)]
    public sealed class PointVxShadowMap : VxShadowMap
    {
        // TODO :
        public override int VoxelResolutionInt => (int)VoxelResolution._4096;

        public override int index { get { return -1; } set { } }
        public override uint bitset => 0;

        private void OnEnable()
        {
            VxShadowMapsManager.Instance.RegisterVxShadowMapComponent(this);
        }
        private void OnDisable()
        {
            VxShadowMapsManager.Instance.UnregisterVxShadowMapComponent(this);
        }

        public override bool IsValid()
        {
            return false;
        }
    }
}
