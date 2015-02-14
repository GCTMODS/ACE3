//fnc_hashSet.sqf
#include "script_component.hpp"

private ["_hash", "_key", "_val", "_index"];
// diag_log text format["%1 HASH SET: %2", diag_tickTime, _this];

_hash = _this select 0;
_key = _this select 1;
_val = _this select 2;
ERRORDATA(3);
try {
	if(VALIDHASH(_hash)) then {
		_index = (_hash select 0) find _key;
		if(_index == -1) then {
			_index = (_hash select 0) find "ACREHASHREMOVEDONOTUSETHISVAL";
			if(_index == -1) then {
				_index = (count (_hash select 0));
			};
			(_hash select 0) set[_index, _key];
		};
		(_hash select 1) set[_index, _val];
	} else {
		ERROR("Input hash is not valid");
	};
} catch {
	HANDLECATCH;
};