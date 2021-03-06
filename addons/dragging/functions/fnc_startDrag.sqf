/*
 * Author: commy2
 *
 * Start the dragging process.
 *
 * Argument:
 * 0: Unit that should do the dragging (Object)
 * 1: Object to drag (Object)
 *
 * Return value:
 * NONE.
 */
#include "script_component.hpp"

private ["_unit", "_target"];

_unit = _this select 0;
_target = _this select 1;

// check weight
private "_weight";
_weight = [_target] call FUNC(getWeight);

if (_weight > GETMVAR(ACE_maxWeightDrag,1E11)) exitWith {
    [localize "STR_ACE_Dragging_UnableToDrag"] call EFUNC(common,displayTextStructured);
};

// add a primary weapon if the unit has none.
// @todo prevent opening inventory when equipped with a fake weapon
if (primaryWeapon _unit == "") then {
    _unit addWeapon "ACE_FakePrimaryWeapon";
};

// select primary, otherwise the drag animation actions don't work.
_unit selectWeapon primaryWeapon _unit;

// prevent multiple players from accessing the same object
[_unit, _target, true] call EFUNC(common,claim);

// can't play action that depends on weapon if it was added the same frame
[{_this playActionNow "grabDrag";}, _unit] call EFUNC(common,execNextFrame);

// move a bit closer and adjust direction when trying to pick up a person
if (_target isKindOf "CAManBase") then {
    _target setDir (getDir _unit + 180);
    _target setPos (getPos _unit vectorAdd (vectorDir _unit vectorMultiply 1.5));

    [_target, "AinjPpneMrunSnonWnonDb_grab", 2, true] call EFUNC(common,doAnimation);
};

// prevents draging and carrying at the same ACE_time
_unit setVariable [QGVAR(isDragging), true, true];

[FUNC(startDragPFH), 0.2, [_unit, _target, ACE_time + 5]] call CBA_fnc_addPerFrameHandler;
