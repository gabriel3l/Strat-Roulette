Handle bumpmineTimer;

public ConfigureBumpmine() {
	bumpmineTimer = CreateTimer(1.0, CheckBumpmineTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public ResetBumpmine() {
	SafeKillTimer(bumpmineTimer);
}

public Action:CheckBumpmineTimer(Handle timer) {
	for (new i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i) && IsPlayerAlive(i) && !IsFakeClient(i)) {
			new mineSlot = GetPlayerWeaponSlot(i, 4);

			if (mineSlot < 0) {
				new mine = GivePlayerItem(i, "weapon_bumpmine");
				EquipPlayerWeapon(i, mine);
			}
		}
	}

	return Plugin_Continue;
}
