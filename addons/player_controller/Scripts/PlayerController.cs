using System.Collections.Generic;
using Godot;

namespace PolarBears.PlayerControllerAddon;

public partial class PlayerController : CharacterBody3D
{
	// User API to important child nodes.
	public Node3D          Head;
	public Bobbing         Bobbing;
	public FieldOfView     FieldOfView;
	public Stamina         Stamina;
	public StairsSystem    StairsSystem;
	public CapsuleCollider CapsuleCollider;
	public Gravity         Gravity;
	public HealthSystem    HealthSystem;
	public Mouse           Mouse;

	[Signal]
	delegate void JumpedEventHandler();
	[Signal]
	delegate void HeadHitCeilingEventHandler();

	[Export(PropertyHint.Range, "0,20,0.1,or_greater")]
	public float WalkSpeed             { get; set; } = 5.0f;
	[Export(PropertyHint.Range, "0,20,0.1,or_greater")]
	public float SprintSpeed           { get; set; } = 7.2f;
	[Export(PropertyHint.Range, "0,10,0.1,or_greater")]
	public float CrouchSpeed           { get; set; } = 2.5f;
	[Export(PropertyHint.Range, "25,100,0.1,or_greater")]
	public float CrouchTransitionSpeed { get; set; } = 25.0f;

	[ExportGroup("Input")]
	[Export]
	public string MoveForwardInputAction;
	[Export]
	public string MoveBackwardInputAction;
	[Export]
	public string StrafeLeftInputAction;
	[Export]
	public string StrafeRightInputAction;
	[Export]
	public string JumpInputAction;
	[Export]
	public string CrouchInputAction;
	[Export]
	public string SprintInputAction;

	private float _currentSpeed;

	private const float DecelerationSpeedFactorFloor = 15.0f;
	private const float DecelerationSpeedFactorAir   = 7.0f;

	private float _lastFrameWasOnFloor = -Mathf.Inf;

	private const int NumOfHeadCollisionDetectors = 4;
	private RayCast3D[] _headCollisionDetectors;

	private bool _wasHeadPreviouslyTouchingCeiling = false;

	public override void _Ready()
	{
		_currentSpeed = WalkSpeed;
		
		Head = GetNode<Node3D>("Head");
		
		_headCollisionDetectors = new RayCast3D[NumOfHeadCollisionDetectors];

		for (int i = 0; i < NumOfHeadCollisionDetectors; i++)
		{
			_headCollisionDetectors[i] = GetNode<RayCast3D>(
				"HeadCollisionDetectors/HeadCollisionDetector" + i);
		}

		// Getting dependencies of the components(In godot we manage this from upwards to downwards not vice versa)
		Camera3D camera = GetNode<Camera3D>("Head/CameraSmooth/Camera3D");

		RayCast3D stairsBelowRayCast3D = GetNode<RayCast3D>("StairsBelowRayCast3D");
		RayCast3D stairsAheadRayCast3D = GetNode<RayCast3D>("StairsAheadRayCast3D");

		Node3D cameraSmooth = GetNode<Node3D>("Head/CameraSmooth");

		AnimationPlayer animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		
		// Getting universal setting from GODOT editor to be in sync
		float gravitySetting = (float)ProjectSettings.GetSetting("physics/3d/default_gravity");

		ColorRect vignetteRect = GetNode<ColorRect>(
			"Head/CameraSmooth/Camera3D/CLVignette(Layer_1)/HealthVignetteRect");
		
		ColorRect distortionRect = GetNode<ColorRect>(
			"Head/CameraSmooth/Camera3D/CLDistortion(Layer_2)/HealthDistortionRect");

		ColorRect blurRect = GetNode<ColorRect>("Head/CameraSmooth/Camera3D/CLBlur(Layer_2)/BlurRect");
		
		Node3D mapNode = GetTree().Root.FindChild("Map", true, false) as Node3D;
		
		// Getting components

		Bobbing = GetNode<Bobbing>("Bobbing");
		Bobbing.Init(camera);

		FieldOfView = GetNode<FieldOfView>("FieldOfView");
		FieldOfView.Init(camera);

		Stamina = GetNode<Stamina>("Stamina");
		Stamina.SetSpeeds(WalkSpeed, SprintSpeed);

		StairsSystem = GetNode<StairsSystem>("StairsSystem");
		StairsSystem.Init(stairsBelowRayCast3D, stairsAheadRayCast3D, cameraSmooth);

		CapsuleCollider = GetNode<CapsuleCollider>("CapsuleCollider");

		Gravity = GetNode<Gravity>("Gravity");
		Gravity.Init(gravitySetting);

		HealthSystem = GetNode<HealthSystem>("HealthSystem");
		
		HealthSystem.HealthSystemInitParams healthSystemParams = new HealthSystem.HealthSystemInitParams()
		{
			Gravity = Gravity,
			Parent = this,
			Camera = camera,
			AnimationPlayer = animationPlayer,
			Head =  Head,
			VignetteRect = vignetteRect,
			DistortionRect = distortionRect,
			BlurRect = blurRect,
		};
		
		HealthSystem.Init(healthSystemParams);
		
		Mouse = GetNode<Mouse>("Mouse");
		Mouse.Init(Head, camera, HealthSystem.IsDead);
	}

	public override void _PhysicsProcess(double delta)
	{
		if (isOnFloorCustom())
		{
			_lastFrameWasOnFloor = Engine.GetPhysicsFrames();
		}

		// Adding the gravity
		if (!isOnFloorCustom())
		{
			Velocity = new Vector3(
				x: Velocity.X,
				y: Velocity.Y - (Gravity.CalculateGravityForce() * (float)delta),
				z: Velocity.Z);
		}

		bool doesCapsuleHaveCrouchingHeight = CapsuleCollider.IsCrouchingHeight();

		bool isPlayerDead = HealthSystem.IsDead();

		// Handle Jumping
		if (IsInputPressed(JumpInputAction, Key.Space, justPressed: true) && isOnFloorCustom()
			&& !doesCapsuleHaveCrouchingHeight && !isPlayerDead)
		{
			Velocity = new Vector3(
				x: Velocity.X,
				y: Gravity.CalculateJumpForce(),
				z: Velocity.Z);
			
			EmitSignal(SignalName.Jumped);
		}

		bool isHeadTouchingCeiling = IsHeadTouchingCeiling();
		
		bool doesCapsuleHaveDefaultHeight = CapsuleCollider.IsDefaultHeight();

		// The code below is required to quickly adjust player's position on Y-axis when there's a ceiling on the
		// trajectory of player's jump and player is standing
		if (isHeadTouchingCeiling && doesCapsuleHaveDefaultHeight)
		{
			Velocity = new Vector3(
				x: Velocity.X,
				y: Velocity.Y - 2.0f,
				z: Velocity.Z);
			if (!_wasHeadPreviouslyTouchingCeiling)
				EmitSignal(SignalName.HeadHitCeiling);
		}

		_wasHeadPreviouslyTouchingCeiling = isHeadTouchingCeiling;

		if (!isPlayerDead)
		{
			
			// Used both for detecting the moment when we enter into crouching mode and the moment when we're already
			// in the crouching mode
			if (IsInputPressed(CrouchInputAction, Key.Ctrl, justPressed: false) ||
				(doesCapsuleHaveCrouchingHeight && isHeadTouchingCeiling))
			{
				CapsuleCollider.Crouch((float)delta, CrouchTransitionSpeed);
				_currentSpeed = CrouchSpeed;
			}
			// Used both for the moment when we exit the crouching mode and for the moment when we just walk
			else
			{
				CapsuleCollider.UndoCrouching((float)delta, CrouchTransitionSpeed);
				_currentSpeed = WalkSpeed;
			}
		}

		// Each component of the boolean statement for sprinting is required
		if (IsInputPressed(SprintInputAction, Key.Shift, justPressed: false) && !isHeadTouchingCeiling &&
			!doesCapsuleHaveCrouchingHeight && !isPlayerDead)
		{
			_currentSpeed = SprintSpeed;
		}

		// Get the input direction
		Vector2 inputDir = GetMovementVector();

		// Basis is a 3x4 matrix. It contains information about scaling and rotation of head.
		// By multiplying our Vector3 by this matrix we're doing multiple things:
		// a) We start to operate in global space;
		// b) We're applying to Vector3 the current rotation of "head" object;
		// c) We're applying to Vector3 the current scaling of "head" object;
		Vector3 direction = (Head.Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();

		if (isPlayerDead)
		{
			direction = Vector3.Zero;
		}

		if (isOnFloorCustom())
		{
			// Set velocity based on input direction when on the floor
			if (direction.Length() > 0)
			{
				float availableSpeed = Stamina.AccountStamina(delta, _currentSpeed);

				float newX = direction.X * availableSpeed;
				float newZ = direction.Z * availableSpeed;

				Velocity = new Vector3(newX, Velocity.Y, newZ);
			}
			// If there is no input, smoothly decelerate the character on the floor
			else
			{
				float xDeceleration = Mathf.Lerp(Velocity.X, direction.X * _currentSpeed,
					(float)delta * DecelerationSpeedFactorFloor);
				float zDeceleration = Mathf.Lerp(Velocity.Z, direction.Z * _currentSpeed,
					(float)delta * DecelerationSpeedFactorFloor);

				Velocity = new Vector3(xDeceleration, Velocity.Y, zDeceleration);
			}
		}
		else
		{
			float xDeceleration = Mathf.Lerp(Velocity.X, direction.X * _currentSpeed,
				(float)delta * DecelerationSpeedFactorAir);
			float zDeceleration = Mathf.Lerp(Velocity.Z, direction.Z * _currentSpeed,
				(float)delta * DecelerationSpeedFactorAir);

			Velocity = new Vector3(xDeceleration, Velocity.Y, zDeceleration);
		}

		if (isPlayerDead)
		{
			MoveAndSlide();
			return;
		}

		Bobbing.CameraBobbingParams cameraBobbingParams = new Bobbing.CameraBobbingParams
		{
			Delta = (float)delta,
			IsOnFloorCustom = isOnFloorCustom(),
			Velocity = Velocity
		};

		Bobbing.PerformCameraBobbing(cameraBobbingParams);

		FieldOfView.FovParameters fovParams = new FieldOfView.FovParameters
		{
			IsCrouchingHeight = CapsuleCollider.IsCrouchingHeight(),
			Delta = (float)delta,
			SprintSpeed = SprintSpeed,
			Velocity = Velocity
		};

		FieldOfView.PerformFovAdjustment(fovParams);

		StairsSystem.UpStairsCheckParams upStairsCheckParams = new StairsSystem.UpStairsCheckParams
		{
			IsOnFloorCustom = isOnFloorCustom(),
			IsCapsuleHeightLessThanNormal = CapsuleCollider.IsCapsuleHeightLessThanNormal(),
			CurrentSpeedGreaterThanWalkSpeed = _currentSpeed > WalkSpeed,
			IsCrouchingHeight = CapsuleCollider.IsCrouchingHeight(),
			Delta = (float)delta,
			FloorMaxAngle = FloorMaxAngle,
			GlobalPositionFromDriver = GlobalPosition,
			Velocity = Velocity,
			GlobalTransformFromDriver = GlobalTransform,
			Rid = GetRid()
		};

		// TODO: SnapUpStairsCheck influences the ability of player to crouch because of `stepHeightY <= 0.01` part
		// Ideally, it should not. SnapUpStairsCheck and SnapDownStairsCheck should be called, when player is actually
		// on the stairs

		StairsSystem.UpStairsCheckResult upStairsCheckResult = StairsSystem.SnapUpStairsCheck(upStairsCheckParams);

		if (upStairsCheckResult.UpdateRequired)
		{
			upStairsCheckResult.Update(this);
		}
		else
		{
			MoveAndSlide();

			StairsSystem.DownStairsCheckParams downStairsCheckParams = new StairsSystem.DownStairsCheckParams
			{
				IsOnFloor = IsOnFloor(),  // TODO: replace on IsOnFloor Custom
				IsCrouchingHeight = CapsuleCollider.IsCrouchingHeight(),
				LastFrameWasOnFloor = _lastFrameWasOnFloor,
				CapsuleDefaultHeight = CapsuleCollider.GetDefaultHeight(),
				CurrentCapsuleHeight = CapsuleCollider.GetCurrentHeight(),
				FloorMaxAngle = FloorMaxAngle,
				VelocityY = Velocity.Y,
				GlobalTransformFromDriver = GlobalTransform,
				Rid = GetRid()
			};

			StairsSystem.DownStairsCheckResult downStairsCheckResult = StairsSystem.SnapDownStairsCheck(
				downStairsCheckParams);

			if (downStairsCheckResult.UpdateIsRequired)
			{
				downStairsCheckResult.Update(this);
			}
		}

		StairsSystem.SlideCameraParams slideCameraParams = new StairsSystem.SlideCameraParams
		{
			CurrentSpeedGreaterThanWalkSpeed = _currentSpeed > WalkSpeed,
			BetweenCrouchingAndNormalHeight  = CapsuleCollider.IsBetweenCrouchingAndNormalHeight(),
			Delta = (float)delta
		};

		StairsSystem.SlideCameraSmoothBackToOrigin(slideCameraParams);
	}

	private bool IsHeadTouchingCeiling()
	{
		for (int i = 0; i < NumOfHeadCollisionDetectors; i++)
		{
			if (_headCollisionDetectors[i].IsColliding())
			{
				return true;
			}
		}

		return false;
	}

	private bool isOnFloorCustom()
	{
		return IsOnFloor() || StairsSystem.WasSnappedToStairsLastFrame();
	}
	
	private Dictionary<Key, bool> previousKeyStates = new();

	private bool IsKeyJustPressed(Key key)
	{
		bool currentState = Input.IsKeyPressed(key);
		bool wasPressed = previousKeyStates.GetValueOrDefault(key, false);
		
		// note: IsInputPressed (the function that calls IsKeyJustPressed) is called every frame while player is alive
		// so, the checks below make sense
		if (currentState)
		{
			previousKeyStates[key] = true;
		}
		else
		{
			previousKeyStates.Remove(key);
		}
	
		return currentState && !wasPressed;
	}

	private bool IsInputPressed(string inputAction, Key fallbackKey, bool justPressed = false)
	{
		bool inputActionSet = !string.IsNullOrEmpty(inputAction);
	
		if (justPressed)
		{
			return (
				inputActionSet && Input.IsActionJustPressed(inputAction) ||
				!inputActionSet && IsKeyJustPressed(fallbackKey)
			);
		}
		
		return (
			inputActionSet && Input.IsActionPressed(inputAction) ||
			!inputActionSet && Input.IsPhysicalKeyPressed(fallbackKey)
		);
	}

	private float GetInputStrength(string inputAction, Key fallbackKey)
	{
		if (string.IsNullOrEmpty(inputAction))
		{
			return Input.IsPhysicalKeyPressed(fallbackKey) ? 1.0f : 0.0f;
		}
		else
		{
			return Input.GetActionStrength(inputAction);
		}
	}

	private Vector2 GetMovementVector() {
		return new Vector2(
			GetInputStrength(StrafeRightInputAction, Key.D) - GetInputStrength(StrafeLeftInputAction, Key.A),
			GetInputStrength(MoveBackwardInputAction, Key.S) - GetInputStrength(MoveForwardInputAction, Key.W)
		);
	}
}
