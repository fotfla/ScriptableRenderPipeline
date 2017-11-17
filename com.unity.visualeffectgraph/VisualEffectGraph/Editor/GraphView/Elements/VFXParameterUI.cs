using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor.Experimental.UIElements.GraphView;
using UnityEngine;
using UnityEngine.Experimental.UIElements;
using UnityEngine.Experimental.UIElements.StyleEnums;
using UnityEngine.Experimental.UIElements.StyleSheets;

namespace UnityEditor.VFX.UI
{
    class VFXParameterUI : VFXStandaloneSlotContainerUI
    {
        PropertyRM m_Property;
        PropertyRM[] m_SubProperties;

        public VFXParameterUI()
        {
        }

        protected override void OnStyleResolved(ICustomStyle style)
        {
            base.OnStyleResolved(style);

            float labelWidth = 70;
            float controlWidth = 120;

            var properties = inputContainer.Query().OfType<PropertyRM>().ToList();

            foreach (var port in properties)
            {
                float portLabelWidth = port.GetPreferredLabelWidth();
                float portControlWidth = port.GetPreferredControlWidth();

                if (labelWidth < portLabelWidth)
                {
                    labelWidth = portLabelWidth;
                }
                if (controlWidth < portControlWidth)
                {
                    controlWidth = portControlWidth;
                }
            }

            foreach (var port in properties)
            {
                port.SetLabelWidth(labelWidth);
            }

            inputContainer.style.width = labelWidth + controlWidth;
        }

        public override void OnDataChanged()
        {
            base.OnDataChanged();
            var presenter = GetPresenter<VFXParameterPresenter>();
            if (presenter == null)
                return;

            if (m_Property == null)
            {
                m_Property = PropertyRM.Create(presenter, 55);
                if (m_Property != null)
                {
                    inputContainer.Add(m_Property);

                    if (!m_Property.showsEverything)
                    {
                        int count = presenter.CreateSubPresenters();
                        m_SubProperties = new PropertyRM[count];

                        for (int i = 0; i < count; ++i)
                        {
                            m_SubProperties[i] = PropertyRM.Create(presenter.GetSubPresenter(i), 55);
                            inputContainer.Add(m_SubProperties[i]);
                        }
                    }
                }
            }
            if (m_Property != null)
                m_Property.Update();
            if (m_SubProperties != null)
            {
                foreach (var subProp in m_SubProperties)
                {
                    subProp.Update();
                }
            }
        }
    }
}
