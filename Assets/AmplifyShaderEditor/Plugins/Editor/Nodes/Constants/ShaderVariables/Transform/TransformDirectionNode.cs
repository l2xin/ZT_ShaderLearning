// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using System;
using UnityEngine;
using UnityEditor;

namespace AmplifyShaderEditor
{
	[Serializable]
	[NodeAttributes( "Transform Direction", "Vector Operators", "Transforms a direction vector from one space to another" )]
	public sealed class TransformDirectionNode : ParentNode
	{
		[SerializeField]
		private TransformSpace m_from = TransformSpace.Object;

		[SerializeField]
		private TransformSpace m_to = TransformSpace.World;

		[SerializeField]
		private bool m_normalize = false;

		private const string NormalizeOptionStr = "Normalize";
		private const string NormalizeFunc = "normalize( {0} )";

		private const string AseObjectToWorldDirVarName = "objToWorldDir";
		private const string AseObjectToWorldDirFormat = "mul( unity_ObjectToWorld, float4( {0}, 0 ) ).xyz";
		private const string AseHDObjectToWorldDirFormat = "mul( GetObjectToWorldMatrix(), float4( {0}, 0 ) ).xyz";

		private const string AseObjectToViewDirVarName = "objToViewDir";
		private const string AseObjectToViewDirFormat = "mul( UNITY_MATRIX_IT_MV, float4( {0}, 0 ) ).xyz";
		private const string AseHDObjectToViewDirFormat = "TransformWorldToViewDir( TransformObjectToWorldDir( {0} ))";

		private const string AseWorldToObjectDirVarName = "worldToObjDir";
		private const string AseWorldToObjectDirFormat = "mul( unity_WorldToObject, float4( {0}, 0 ) ).xyz";
		private const string AseHDWorldToObjectDirFormat = "mul( GetWorldToObjectMatrix(), float4( {0}, 0 ) ).xyz";


		private const string AseWorldToViewDirVarName = "worldToViewDir";
		private const string AseWorldToViewDirFormat = "mul( UNITY_MATRIX_V, float4( {0}, 0 ) ).xyz";

		private const string AseViewToObjectDirVarName = "viewToObjDir";
		private const string AseViewToObjectDirFormat = "mul( UNITY_MATRIX_T_MV, float4( {0}, 0 ) ).xyz";

		private const string AseViewToWorldDirVarName = "viewToWorldDir";
		private const string AseViewToWorldDirFormat = "mul( UNITY_MATRIX_I_V, float4( {0}, 0 ) ).xyz";

		private const string FromStr = "From";
		private const string ToStr = "To";
		private const string SubtitleFormat = "{0} to {1}";

		private readonly string[] m_spaceOptions =
		{
			"Object Space",
			"World Space",
			"View Space",
		};

		protected override void CommonInit( int uniqueId )
		{
			base.CommonInit( uniqueId );
			AddInputPort( WirePortDataType.FLOAT3, false, Constants.EmptyPortValue );
			AddOutputVectorPorts( WirePortDataType.FLOAT3, "XYZ" );
			m_useInternalPortData = true;
			m_autoWrapProperties = true;
			m_previewShaderGUID = "74e4d859fbdb2c0468de3612145f4929";
			m_textLabelWidth = 100;
			UpdateSubtitle();
		}

		private void UpdateSubtitle()
		{
			SetAdditonalTitleText( string.Format( SubtitleFormat, m_from, m_to ) );
		}

		public override void DrawProperties()
		{
			base.DrawProperties();
			EditorGUI.BeginChangeCheck();
			m_from = (TransformSpace)EditorGUILayoutPopup( FromStr, (int)m_from, m_spaceOptions );
			m_to = (TransformSpace)EditorGUILayoutPopup( ToStr, (int)m_to, m_spaceOptions );
			m_normalize = EditorGUILayoutToggle( NormalizeOptionStr, m_normalize );
			if( EditorGUI.EndChangeCheck() )
			{
				UpdateSubtitle();
			}
		}

		public override string GenerateShaderForOutput( int outputId, ref MasterNodeDataCollector dataCollector, bool ignoreLocalvar )
		{
			if( m_outputPorts[ 0 ].IsLocalValue( dataCollector.PortCategory ) )
				return GetOutputVectorItem( 0, outputId, m_outputPorts[ 0 ].LocalValue( dataCollector.PortCategory ) );

			string result = m_inputPorts[ 0 ].GeneratePortInstructions( ref dataCollector );
			string varName = string.Empty;

			switch( m_from )
			{
				case TransformSpace.Object:
				switch( m_to )
				{
					default:
					case TransformSpace.Object:
					break;
					case TransformSpace.World:
					if( dataCollector.IsTemplate && dataCollector.TemplateDataCollectorInstance.CurrentSRPType == TemplateSRPType.HD )
						result = string.Format( AseHDObjectToWorldDirFormat, result );
					else
						result = string.Format( AseObjectToWorldDirFormat, result );
					varName = AseObjectToWorldDirVarName + OutputId;
					break;
					case TransformSpace.View:
					if( dataCollector.IsTemplate && dataCollector.TemplateDataCollectorInstance.CurrentSRPType == TemplateSRPType.HD )
						result = string.Format( AseHDObjectToViewDirFormat, result );
					else
						result = string.Format( AseObjectToViewDirFormat, result );
					varName = AseObjectToViewDirVarName + OutputId;
					break;
				}
				break;
				case TransformSpace.World:
				switch( m_to )
				{
					case TransformSpace.Object:
					if( dataCollector.IsTemplate && dataCollector.TemplateDataCollectorInstance.CurrentSRPType == TemplateSRPType.HD )
						result = string.Format( AseHDWorldToObjectDirFormat, result );
					else
						result = string.Format( AseWorldToObjectDirFormat, result );
					varName = AseWorldToObjectDirVarName + OutputId;
					break;
					default:
					case TransformSpace.World:
					break;
					case TransformSpace.View:
					result = string.Format( AseWorldToViewDirFormat, result );
					varName = AseWorldToViewDirVarName + OutputId;
					break;
				}
				break;
				case TransformSpace.View:
				switch( m_to )
				{
					case TransformSpace.Object:
					result = string.Format( AseViewToObjectDirFormat, result );
					varName = AseViewToObjectDirVarName + OutputId;
					break;
					case TransformSpace.World:
					result = string.Format( AseViewToWorldDirFormat, result );
					varName = AseViewToWorldDirVarName + OutputId;
					break;
					default:
					case TransformSpace.View:
					break;
				}
				break;
				default:
				break;
			}

			if( m_normalize )
				result = string.Format( NormalizeFunc, result );

			RegisterLocalVariable( 0, result, ref dataCollector, varName );
			return GetOutputVectorItem( 0, outputId, m_outputPorts[ 0 ].LocalValue( dataCollector.PortCategory ) );
		}

		public override void ReadFromString( ref string[] nodeParams )
		{
			base.ReadFromString( ref nodeParams );
			m_from = (TransformSpace)Enum.Parse( typeof( TransformSpace ), GetCurrentParam( ref nodeParams ) );
			m_to = (TransformSpace)Enum.Parse( typeof( TransformSpace ), GetCurrentParam( ref nodeParams ) );
			m_normalize = Convert.ToBoolean( GetCurrentParam( ref nodeParams ) );
			UpdateSubtitle();
		}

		public override void WriteToString( ref string nodeInfo, ref string connectionsInfo )
		{
			base.WriteToString( ref nodeInfo, ref connectionsInfo );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_from );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_to );
			IOUtils.AddFieldValueToString( ref nodeInfo, m_normalize );
		}
	}
}
