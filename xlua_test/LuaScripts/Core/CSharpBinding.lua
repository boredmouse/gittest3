-- @Author: Jax
-- @Date:   2020-04-27 16:26:18
-- @Last Modified by:   Jax
-- @Last Modified time: 2020-04-28 09:27:46
------------------------- UnityEngine--------------------------
--- @type UnityEngine.Vector2
LuaClass.Vector2 = CS.UnityEngine.Vector2
--- @type UnityEngine.Vector3
LuaClass.Vector3 = CS.UnityEngine.Vector3
LuaClass.Quaternion = CS.UnityEngine.Quaternion
---@type UnityEngine.Object
LuaClass.Object = CS.UnityEngine.Object
--- @type UnityEngine.GameObject
LuaClass.GameObject = CS.UnityEngine.GameObject
--- @type UnityEngine.Color
LuaClass.Color = CS.UnityEngine.Color
--- @type UnityEngine.Time
LuaClass.Time = CS.UnityEngine.Time
LuaClass.GC = CS.System.GC
--- @type UnityEngine.Application
LuaClass.Application = CS.UnityEngine.Application
LuaClass.RuntimePlatform = CS.UnityEngine.RuntimePlatform
--- @type UnityEngine.Debug
LuaClass.Debug = CS.UnityEngine.Debug
LuaClass.Rect = CS.UnityEngine.Rect
LuaClass.Sprite = CS.UnityEngine.Sprite
LuaClass.TextMesh = CS.UnityEngine.TextMesh
LuaClass.LayerMask = CS.UnityEngine.LayerMask
---@type UnityEngine.Animator
LuaClass.Animator = CS.UnityEngine.Animator
LuaClass.AnimatorUpdateMode = CS.UnityEngine.AnimatorUpdateMode
LuaClass.Animation = CS.UnityEngine.Animation
LuaClass.AnimatorCullingMode = CS.UnityEngine.AnimatorCullingMode
LuaClass.RuntimeAnimatorController = CS.UnityEngine.RuntimeAnimatorController
LuaClass.NavMeshAgent = CS.UnityEngine.NavMeshAgent
LuaClass.PolygonCollider2D = CS.UnityEngine.PolygonCollider2D
--- @type UnityEngine.KeyCode
LuaClass.KeyCode = CS.UnityEngine.KeyCode
--- @type UnityEngine.Input
LuaClass.Input = CS.UnityEngine.Input
---@type InputExtension
LuaClass.InputExtension = CS.InputExtension

LuaClass.Renderer = CS.UnityEngine.Renderer
LuaClass.Camera = CS.UnityEngine.Camera
--- @type UnityEngine.Screen
LuaClass.Screen = CS.UnityEngine.Screen
LuaClass.GUIText = CS.UnityEngine.GUIText
LuaClass.AnimatorControllerParameterType = CS.UnityEngine.AnimatorControllerParameterType
--- @type UnityEngine.RectTransform
LuaClass.RectTransform = CS.UnityEngine.RectTransform
----- @type UnityEngine.RectTransform.Edge
LuaClass.RectTransform.Edge = CS.UnityEngine.RectTransform.Edge
--- @type UnityEngine.Transform
LuaClass.Transform = CS.UnityEngine.Transform
LuaClass.Text = CS.UnityEngine.UI.Text
LuaClass.Image = CS.UnityEngine.UI.Image
LuaClass.RawImage = CS.UnityEngine.UI.RawImage
LuaClass.Button = CS.UnityEngine.UI.Button
LuaClass.CanvasGroup = CS.UnityEngine.CanvasGroup
LuaClass.Canvas = CS.UnityEngine.Canvas
--- @type UnityEngine.Mathf
-- LuaClass.Mathf 			= CS.UnityEngine.Mathf
LuaClass.CharacterController = CS.UnityEngine.CharacterController
LuaClass.SkinnedMeshRenderer = CS.UnityEngine.SkinnedMeshRenderer
LuaClass.Mesh = CS.UnityEngine.Mesh
LuaClass.NavMesh = CS.UnityEngine.NavMesh
LuaClass.NavMeshPath = CS.UnityEngine.NavMeshPath
LuaClass.RectOffset = CS.UnityEngine.RectOffset
LuaClass.Toggle = CS.UnityEngine.UI.Toggle
LuaClass.ScrollRect = CS.UnityEngine.UI.ScrollRect
--- @type UnityEngine.UI.LayoutUtility
LuaClass.LayoutUtility = CS.UnityEngine.UI.LayoutUtility
LuaClass.LayoutElement = CS.UnityEngine.UI.LayoutElement
LuaClass.LayoutRebuilder = CS.UnityEngine.UI.LayoutRebuilder
LuaClass.VerticalLayoutGroup = CS.UnityEngine.UI.VerticalLayoutGroup
--- @type UnityEngine.UI.GridLayoutGroup
LuaClass.GridLayoutGroup = CS.UnityEngine.UI.GridLayoutGroup
LuaClass.MaskableGraphic = CS.UnityEngine.UI.MaskableGraphic
LuaClass.SphereCollider = CS.UnityEngine.SphereCollider
LuaClass.Collider = CS.UnityEngine.Collider
LuaClass.Collider2D = CS.UnityEngine.Collider2D
LuaClass.CapsuleCollider = CS.UnityEngine.CapsuleCollider
---@type UnityEngine.PlayerPrefs
LuaClass.PlayerPrefs = CS.UnityEngine.PlayerPrefs
LuaClass.EventSystems = CS.UnityEngine.EventSystems
LuaClass.GUIUtility = CS.UnityEngine.GUIUtility
LuaClass.RenderTexture = CS.UnityEngine.RenderTexture
LuaClass.Texture2D = CS.UnityEngine.Texture2D
LuaClass.TextureFormat = CS.UnityEngine.TextureFormat
LuaClass.RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
LuaClass.RenderTextureReadWrite = CS.UnityEngine.RenderTextureReadWrite
LuaClass.Shader = CS.UnityEngine.Shader
LuaClass.EventSystem = CS.UnityEngine.EventSystem
LuaClass.RenderSettings = CS.UnityEngine.RenderSettings
LuaClass.MeshFilter = CS.UnityEngine.MeshFilter
LuaClass.ParticleSystem = CS.UnityEngine.ParticleSystem
LuaClass.Material = CS.UnityEngine.Material
LuaClass.StaticBatchingUtility = CS.UnityEngine.StaticBatchingUtility
LuaClass.FogMode = CS.UnityEngine.FogMode
LuaClass.SceneManager = CS.UnityEngine.SceneManagement.SceneManager
LuaClass.SpriteRenderer = CS.UnityEngine.SpriteRenderer
LuaClass.LineRenderer = CS.UnityEngine.LineRenderer
LuaClass.SystemInfo = CS.UnityEngine.SystemInfo
LuaClass.LightmapSettings = CS.UnityEngine.LightmapSettings
LuaClass.LightmapsMode = CS.UnityEngine.LightmapsMode
LuaClass.RectTransformUtility = CS.UnityEngine.RectTransformUtility
--在运行时将General GI的Directional Mode的设置为Non-Directional
LuaClass.LightmapSettings.lightmapsMode = LuaClass.LightmapsMode.NonDirectional
--
LuaClass.QualitySettings = CS.UnityEngine.QualitySettings
LuaClass.QualitySettings.lodBias = 1
--- @type UnityEngine.Profiler
LuaClass.Profiler = CS.UnityEngine.Profiler
LuaClass.ThreadPriority = CS.UnityEngine.ThreadPriority
--- @type UnityEngine.TextAnchor
LuaClass.TextAnchor = CS.UnityEngine.TextAnchor

LuaClass.Light = CS.UnityEngine.Light
LuaClass.Resources = CS.UnityEngine.Resources
LuaClass.TextAsset = CS.UnityEngine.TextAsset

LuaClass.VideoPlayer = CS.UnityEngine.Video.VideoPlayer

LuaClass.Ping = CS.UnityEngine.Ping


------------------------- BombMan-------------------
LuaClass.AssetManager = CS.BombMan.AssetManager
LuaClass.AssetPacketEntity = CS.BombMan.AssetPacketEntity
LuaClass.AssetTypeEnum = CS.BombMan.AssetTypeEnum
LuaClass.LuaBehavior = CS.BombMan.LuaBehaviour
LuaClass.MapComponent = CS.BombMan.MapComponent
LuaClass.AppConfig = CS.BombMan.AppConfig
LuaClass.MapSorting = CS.BombMan.MapSorting
LuaClass.Filter = CS.TrueSync.Physics2D.Dynamics.Filter
LuaClass.Npc = CS.BombMan.Npc
---@type BombMan.MathUtil
LuaClass.BombManMathUtil = CS.BombMan.MathUtil

-- LuaClass.SocketManager = CS.HiSocket.SocketManager
LuaClass.DDTPackage = CS.HiSocket.DDTPackage
-- LuaClass.ByteBuffer = CS.HiSocket.ByteBuffer
LuaClass.AnimatorStateMachineBehaviour = CS.BombMan.AnimatorStateMachineBehaviour
LuaClass.KAssetBundleLoader = CS.KEngine.KAssetBundleLoader
LuaClass.CSMain = CS.Main

-- 特效
LuaClass.FocusMotionBlurEffect = CS.BombMan.FocusMotionBlurEffect
LuaClass.BlastWaveEffect = CS.BombMan.BlastWaveEffect

-- 镜头效果
LuaClass.CameraRotation = CS.BombMan.CameraRotation


------------------------- .NET Namespace-------------------
LuaClass.File = CS.System.IO.File
--- @type System.DateTime
LuaClass.DateTime = CS.System.DateTime
--- @type System.String
LuaClass.String = CS.System.String
------------------------ spine-------------------------------
-- LuaClass.SkeletonRenderSeparator = CS.Spine.Unity.Modules.SkeletonRenderSeparator
LuaClass.SkeletonRenderSeparator = CS.Spine.Unity.SkeletonRenderSeparator
LuaClass.SkeletonAnimation = CS.Spine.Unity.SkeletonAnimation
LuaClass.SkeletonMecanim = CS.Spine.Unity.SkeletonMecanim
LuaClass.SkeletonRenderer = CS.Spine.Unity.SkeletonRenderer
LuaClass.AssetFileLoader = CS.KEngine.KAssetFileLoader
LuaClass.RegionFollower = CS.Spine.Unity.RegionFollower
LuaClass.MeshRenderer = CS.UnityEngine.MeshRenderer
LuaClass.SortingGroup = CS.UnityEngine.Rendering.SortingGroup
LuaClass.RenderMode = CS.UnityEngine.RenderMode
LuaClass.SkeletonUtility = CS.Spine.Unity.SkeletonUtility
LuaClass.SkeletonUtilityBone = CS.Spine.Unity.SkeletonUtilityBone


------------------------- 3rd/Plugins Namespace-------------------

LuaClass.ProCamera2D = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2D
LuaClass.ProCamera2DForwardFocus = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DForwardFocus
LuaClass.ProCamera2DMoveTo = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DMoveTo
LuaClass.ProCamera2DShake = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DShake
LuaClass.ProCamera2DZoomToFitTargets = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DZoomToFitTargets
LuaClass.ProCamera2DZoom = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DZoom
LuaClass.ProCamera2DDragAndZoom = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DDragAndZoom
LuaClass.ProCamera2DPanAndZoom = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DPanAndZoom
LuaClass.ProCamera2DHorizontalForward = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DHorizontalForward
LuaClass.ProCamera2DLookAtTarget = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DLookAtTarget
LuaClass.ProCamera2DNumericBoundaries = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DNumericBoundaries
LuaClass.ProCamera2DMultitarget = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DMultitarget
LuaClass.ProCamera2DZoomToFitTargets = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DZoomToFitTargets
LuaClass.ProCamera2DSimpleShake = CS.Com.LuisPedroFonseca.ProCamera2D.ProCamera2DSimpleShake
LuaClass.CameraImportentDebug = CS.Com.LuisPedroFonseca.ProCamera2D.CameraImportentDebug
LuaClass.UpdateType = CS.Com.LuisPedroFonseca.ProCamera2D.UpdateType

--===========================================
LuaClass.SceneObjectLabel = CS.BombMan.SceneObjectLabel

-- ========================================FairyGui=============================
---@type FairyGUI.EventContext
LuaClass.GuiEventContext = CS.FairyGUI.EventContext
---@type FairyGUI.EventListener
LuaClass.GuiEventListener = CS.FairyGUI.EventListener
---@type FairyGUI.EventDispatcher
LuaClass.GuiEventDispatcher = CS.FairyGUI.EventDispatcher
---@type FairyGUI.InputEvent
LuaClass.GuiInputEvent = CS.FairyGUI.InputEvent
---@type FairyGUI.NTexture
LuaClass.GuiNTexture = CS.FairyGUI.NTexture
---@type FairyGUI.Container
LuaClass.GuiContainer = CS.FairyGUI.Container
---@type FairyGUI.Image
LuaClass.GuiImage = CS.FairyGUI.Image
---@type FairyGUI.Stage
LuaClass.GuiStage = CS.FairyGUI.Stage
---@type FairyGUI.Controller
LuaClass.GuiController = CS.FairyGUI.Controller
---@type FairyGUI.GObject
LuaClass.GuiGObject = CS.FairyGUI.GObject
---@type FairyGUI.GGraph
LuaClass.GuiGGraph = CS.FairyGUI.GGraph
---@type FairyGUI.GGroup
LuaClass.GuiGGroup = CS.FairyGUI.GGroup
---@type FairyGUI.GImage
LuaClass.GuiGImage = CS.FairyGUI.GImage
---@type FairyGUI.GLoader
LuaClass.GuiGLoader = CS.FairyGUI.GLoader
---@type FairyGUI.GMovieClip
LuaClass.GuiGMovieClip = CS.FairyGUI.GMovieClip
---@type FairyGUI.TextFormat
LuaClass.GuiTextFormat = CS.FairyGUI.TextFormat
---@type FairyGUI.GTextField
LuaClass.GuiGTextField = CS.FairyGUI.GTextField
---@type FairyGUI.GRichTextField
LuaClass.GuiGRichTextField = CS.FairyGUI.GRichTextField
---@type FairyGUI.GTextInput
LuaClass.GuiGTextInput = CS.FairyGUI.GTextInput
---@type FairyGUI.GComponent
LuaClass.GuiGComponent = CS.FairyGUI.GComponent
---@type FairyGUI.GList
LuaClass.GuiGList = CS.FairyGUI.GList
---@type FairyGUI.GRoot
LuaClass.GuiGRoot = CS.FairyGUI.GRoot
---@type FairyGUI.GLabel
LuaClass.GuiGLabel = CS.FairyGUI.GLabel
---@type FairyGUI.GButton
LuaClass.GuiGButton = CS.FairyGUI.GButton
---@type FairyGUI.GComboBox
LuaClass.GuiGComboBox = CS.FairyGUI.GComboBox
---@type FairyGUI.GProgressBar
LuaClass.GuiGProgressBar = CS.FairyGUI.GProgressBar
---@type FairyGUI.GSlider
LuaClass.GuiGSlider = CS.FairyGUI.GSlider
---@type FairyGUI.PopupMenu
LuaClass.GuiPopupMenu = CS.FairyGUI.PopupMenu
---@type FairyGUI.ScrollPane
LuaClass.GuiScrollPane = CS.FairyGUI.ScrollPane
---@type FairyGUI.Transition
LuaClass.GuiTransition = CS.FairyGUI.Transition
---@type FairyGUI.UIPackage
LuaClass.GuiUIPackage = CS.FairyGUI.UIPackage
---@type FairyGUI.Window
LuaClass.GuiWindow = CS.FairyGUI.Window
---@type FairyGUI.GObjectPool
LuaClass.GuiGObjectPool = CS.FairyGUI.GObjectPool
---@type FairyGUI.Relations
LuaClass.GuiRelations = CS.FairyGUI.Relations
---@type FairyGUI.RelationType
LuaClass.GuiRelationType = CS.FairyGUI.RelationType
---@type FairyGUI.UIPanel
LuaClass.GuiUIPanel = CS.FairyGUI.UIPanel
---@type FairyGUI.UIPainter
LuaClass.GuiUIPainter = CS.FairyGUI.UIPainter
---@type FairyGUI.TypingEffect
LuaClass.GuiTypingEffect = CS.FairyGUI.TypingEffect
---@type FairyGUI.BlurFilter
LuaClass.GuiBlurFilter = CS.FairyGUI.BlurFilter
---@type FairyGUI.ColorFilter
LuaClass.GuiColorFilter = CS.FairyGUI.ColorFilter
---@type FairyGUI.GoWrapper
LuaClass.GuiGoWrapper = CS.FairyGUI.GoWrapper
---@type FairyGUI.FontManager
LuaClass.GuiFontManager = CS.FairyGUI.FontManager
---@type FairyGUI.UIConfig
LuaClass.GuiUIConfig = CS.FairyGUI.UIConfig
---@type FairyGUI.UIObjectFactory
LuaClass.GuiUIObjectFactory = CS.FairyGUI.UIObjectFactory

---@type FairyGUI.LongPressGesture
LuaClass.GuiLongPressGesture = CS.FairyGUI.LongPressGesture
LuaClass.ListItemProvider = CS.FairyGUI.ListItemProvider
---@type FairyGUI.GPath
LuaClass.GuiGPath = CS.FairyGUI.GPath
---@type FairyGUI.GPathPoint
LuaClass.GuiGPathPoint = CS.FairyGUI.GPathPoint
---@type FairyGUI.GTween
LuaClass.GuiGTween = CS.FairyGUI.GTween
---@type FairyGUI.FillType
LuaClass.GuiFillType = CS.FairyGUI.FillType
LuaClass.GuiChildrenRenderOrder = CS.FairyGUI.ChildrenRenderOrder

-------------------- Wwise --------------------
LuaClass.AkSoundEngine = CS.AkSoundEngine
LuaClass.AK = CS.AK
LuaClass.AudioSystem = CS.BombMan.AudioSystem
---@type TrueSync.FP
LuaClass.FP = CS.TrueSync.FP
---@type TrueSync.TSMath
LuaClass.TSMath = CS.TrueSync.TSMath
LuaClass.TSMatrix = CS.TrueSync.TSMatrix
LuaClass.TSMatrix4x4 = CS.TrueSync.TSMatrix4x4
LuaClass.TSQuaternion = CS.TrueSync.TSQuaternion
---@type TrueSync.TSRandom
LuaClass.TSRandom = CS.TrueSync.TSRandom
---@type TrueSync.TSVector
LuaClass.TSVector = CS.TrueSync.TSVector
---@type TrueSync.TSVector2
LuaClass.TSVector2 = CS.TrueSync.TSVector2
LuaClass.TSVector4 = CS.TrueSync.TSVector4
-- LuaClass.TSTransform2D = CS.TrueSync.TSTransform2D
-- LuaClass.TSRigidBody2D = CS.TrueSync.TSRigidBody2D
-- LuaClass.TSBoxCollider2D = CS.TrueSync.TSBoxCollider2D
---@type TrueSync.Physics2DWorldManager
LuaClass.Physics2DWorldManager = CS.TrueSync.Physics2DWorldManager
LuaClass.PhysicsManager = CS.TrueSync.PhysicsManager
LuaClass.BodyType = CS.TrueSync.Physics2D.Dynamics.BodyType
LuaClass.Stopwatch = CS.System.Diagnostics.Stopwatch
---@type TrueSync.FSBodyComponent
LuaClass.FSBodyComponent = CS.TrueSync.FSBodyComponent
---@type TrueSync.FSTransformComponent
LuaClass.FSTransformComponent = CS.TrueSync.FSTransformComponent
---@type TrueSync.Physics2D.Collision.Shapes.PolygonShape
LuaClass.PolygonShape = CS.TrueSync.Physics2D.Collision.Shapes.PolygonShape
---@type TrueSync.Physics2D.Collision.Shapes.CircleShape
LuaClass.CircleShape = CS.TrueSync.Physics2D.Collision.Shapes.CircleShape
---@type TrueSync.Physics2D.Collision.Shapes.EdgeShape
LuaClass.EdgeShape = CS.TrueSync.Physics2D.Collision.Shapes.EdgeShape
---@type TrueSync.Physics2D.Collision.Shapes.ShapeType
LuaClass.ShapeType = CS.TrueSync.Physics2D.Collision.Shapes.ShapeType
LuaClass.Vertices = CS.TrueSync.Physics2D.Vertices
---@type TrueSync.Physics2D.Dynamics.Fixture
LuaClass.Fixture = CS.TrueSync.Physics2D.Dynamics.Fixture
LuaClass.Category = CS.TrueSync.Physics2D.Dynamics.Category
LuaClass.InterpolateMode = CS.TrueSync.FSBodyComponent.InterpolateMode
LuaClass.FSHelper = CS.TrueSync.FSHelper
LuaClass.BodyDef = CS.TrueSync.Physics2D.Dynamics.BodyDef
LuaClass.MassData = CS.TrueSync.Physics2D.Collision.Shapes.MassData
LuaClass.RayCastOutput = CS.TrueSync.Physics2D.Collision.Collider.RayCastOutput
LuaClass.RayCastInput = CS.TrueSync.Physics2D.Collision.Collider.RayCastInput
---@type TrueSync.Physics2D.MathUtils
LuaClass.Physics2DMathUtils = CS.TrueSync.Physics2D.MathUtils

LuaClass.BoxCollider2D = CS.UnityEngine.BoxCollider2D
LuaClass.Rigidbody2D = CS.UnityEngine.Rigidbody2D
LuaClass.Physics2D_Settings = CS.TrueSync.Physics2D.Settings
LuaClass.BreakObject = CS.BombMan.BreakObject
LuaClass.RoomObject = CS.BombMan.RoomObject
LuaClass.BackWall = CS.BombMan.BackWall
---@type BombMan.Modifier
LuaClass.Modifier = CS.BombMan.Modifier
---@type BombMan.FactorModifier
LuaClass.FactorModifier = CS.BombMan.FactorModifier
---@type BombMan.GameModifier
LuaClass.GameModifier = CS.BombMan.GameModifier

LuaClass.ExplosionForceModify = CS.ExplosionForceModify



---@class BombMan.Sdk.ISdk
---@field analytics BombMan.Sdk.Analytics
---@field crashlytics BombMan.Sdk.Crashlytics
---@field auth BombMan.Sdk.Auth
---@field messaging BombMan.Sdk.Messaging
local ISdk = nil

