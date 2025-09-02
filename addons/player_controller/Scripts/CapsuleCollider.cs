﻿using Godot;

namespace PolarBears.PlayerControllerAddon;

public partial class CapsuleCollider : CollisionShape3D
{
	[Export(PropertyHint.Range, "0,5.0,0.01,suffix:m,or_greater")]
	public float CapsuleDefaultHeight { get; set; } = 2.0f;
	[Export(PropertyHint.Range, "0,5.0,0.01,suffix:m,or_greater")]
	public float CapsuleCrouchHeight  { get; set; } = 1.0f;

	public float GetCurrentHeight() { return _shape.Height; }
	public float GetDefaultHeight() { return CapsuleDefaultHeight; }

	private CapsuleShape3D _shape;

	public override void _Ready()
	{
		_shape = Shape as CapsuleShape3D;
		_shape.Height = CapsuleDefaultHeight;
	}

	public bool IsCapsuleHeightLessThanNormal()
	{
		return _shape.Height < CapsuleDefaultHeight;
	}

	public bool IsBetweenCrouchingAndNormalHeight()
	{
		return _shape.Height > CapsuleCrouchHeight && _shape.Height < CapsuleDefaultHeight;
	}

	public bool IsDefaultHeight()
	{
		return Mathf.IsEqualApprox(_shape.Height,  CapsuleDefaultHeight);
	}

	public bool IsCrouchingHeight()
	{
		return Mathf.IsEqualApprox(_shape.Height, CapsuleCrouchHeight);
	}

	public void Crouch(float delta, float crouchTransitionSpeed)
	{
		float newHeight = _shape.Height - delta * crouchTransitionSpeed;
		_shape.Height = Mathf.Clamp(newHeight, CapsuleCrouchHeight, CapsuleDefaultHeight);
	}

	public void UndoCrouching(float delta, float crouchTransitionSpeed)
	{
		float newHeight = _shape.Height + delta * crouchTransitionSpeed;
		_shape.Height = Mathf.Clamp(newHeight, CapsuleCrouchHeight, CapsuleDefaultHeight);
	}
}
