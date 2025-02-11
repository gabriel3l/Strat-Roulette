public void ReadNewRound() {
	int numberOfStrats = GetNumberOfStrats();

	/* PrintToServer("Number of strats: %d", numberOfStrats); */

	KeyValues kv = new KeyValues("Strats");
	kv.ImportFromFile(STRAT_FILE);

	ArrayList possibleRoundNumbers = new ArrayList();

	for (int i = 1; i <= numberOfStrats; i++) {
		if (i != lastRound) {
			possibleRoundNumbers.Push(i);
		}
	}

	int roundNumber = possibleRoundNumbers.Get(GetRandomInt(0, possibleRoundNumbers.Length - 1));

	char roundNumberString[16];

	if (forceNextRound) {
		Format(roundNumberString, sizeof(roundNumberString), forceRoundNumber);
		forceNextRound = false;
		lastRound = StringToInt(voteRoundNumber);
	} else if (nextRoundVoted) {
		Format(roundNumberString, sizeof(roundNumberString), voteRoundNumber);
		nextRoundVoted = false;
		lastRound = StringToInt(voteRoundNumber);
	} else {
		IntToString(roundNumber, roundNumberString, sizeof(roundNumberString));
		lastRound = roundNumber;
	}

	if (!kv.JumpToKey(roundNumberString)) {
		PrintToServer("Strat number %s could not be found!", roundNumberString);

		delete kv;
		return;
	}

	PrintToServer("Picked strat %s", roundNumberString);

	char roundName[256];
	kv.GetString("name", roundName, sizeof(roundName), "No name round!");

	char descriptionOverride[3];
	kv.GetString("descoverride", descriptionOverride, sizeof(descriptionOverride), "0");

	char description[2048];
	kv.GetString("description", description, sizeof(description), "");

	SendMessageAll(" ");
	SendMessageAll("{LIGHT_BLUE}-----------------------------------------------------------------------------------------");
	SendMessageAll("%t", roundName);
	SendMessageAll(" ");
	SendMessageAll("%t", description);
	SendMessageAll("{LIGHT_BLUE}-----------------------------------------------------------------------------------------");
	SendMessageAll(" ");

	for (int client = 1; client <= MaxClients; client++) {
		if (IsClientInGame(client) && !IsFakeClient(client)) {
			PrintToConsole(client, "%t", "ConsoleRoundName");
			PrintToConsole(client, "	%t", roundName);

			PrintToConsole(client, "%t", "ConsoleDescription");
			PrintToConsole(client, "	%t", description);
			if (StrEqual(descriptionOverride, "0")) {
				if (killRoundActive) {
					PrintToConsole(client, "%t", "ConsoleRoundInfoElimination");
				} else if (winnerTeam == CS_TEAM_T) {
					PrintToConsole(client, "%t", "ConsoleRoundInfoEliminationTerroristWinTimeUp");
				} else if (winnerTeam == -1) {
					PrintToConsole(client, "%t", "ConsoleRoundInfoEliminationDrawTimeUp");
				} else {
					PrintToConsole(client, "%t", "ConsoleRoundInfoDefault");
				}
			}
		}
	}

	PrintCenterTextAll("%t", roundName);

	char keyValue[500];
	kv.GetString("noknife", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureNoKnife();
		resetFunctions[resetFunctionsLength++] = ResetNoKnife;
	}

	kv.GetString("weapon", keyValue, sizeof(keyValue), "weapon_none");
	if (!StrEqual(keyValue, "weapon_none")) {
		ConfigureWeapons(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetWeapons;
	}

	kv.GetString("health", keyValue, sizeof(keyValue), "100");
	if (!StrEqual(keyValue, "100")) {
		ConfigureHealth(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetHealth;
	}

	kv.GetString("defuser", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureDefuser();
		resetFunctions[resetFunctionsLength++] = ResetDefuser;
	}

	kv.GetString("armor", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureArmor(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetArmor;
	}

	kv.GetString("helmet", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureHelmet();
		resetFunctions[resetFunctionsLength++] = ResetHelmet;
	}

	kv.GetString("noc4", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureNoC4();
		resetFunctions[resetFunctionsLength++] = ResetNoC4;
	}

	kv.GetString("infiniteammo", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureInfiniteAmmo(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetInfiniteAmmo;
	}

	kv.GetString("thirdperson", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureThirdPerson();
		resetFunctions[resetFunctionsLength++] = ResetThirdPerson;
	}

	kv.GetString("collision", keyValue, sizeof(keyValue), "default");
	if (!StrEqual(keyValue, "default")) {
		ConfigureCollision(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetCollision;
	}

	kv.GetString("infinitenade", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureInfiniteNades();
		resetFunctions[resetFunctionsLength++] = ResetInfiniteNades;
	}

	kv.GetString("speed", keyValue, sizeof(keyValue), "1.0");
	if (!StrEqual(keyValue, "1.0")) {
		ConfigureSpeed(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetSpeed;
	}

	kv.GetString("gravity", keyValue, sizeof(keyValue), "800");
	if (!StrEqual(keyValue, "800")) {
		ConfigureGravity(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetGravity;
	}

	kv.GetString("norecoil", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureNoRecoil();
		resetFunctions[resetFunctionsLength++] = ResetNoRecoil;
	}

	kv.GetString("vampire", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureVampire();
		resetFunctions[resetFunctionsLength++] = ResetVampire;
	}

	kv.GetString("pcolor", keyValue, sizeof(keyValue), "null");
	if (!StrEqual(keyValue, "null")) {
		ConfigurePlayerColors(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetPlayerColors;
	}

	kv.GetString("backwards", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureBackwards();
		resetFunctions[resetFunctionsLength++] = ResetBackwards;
	}

	kv.GetString("fov", keyValue, sizeof(keyValue), "90");
	if (!StrEqual(keyValue, "90")) {
		ConfigureFov(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetFov;
	}

	kv.GetString("chickendef", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureChickenDefuse();
		resetFunctions[resetFunctionsLength++] = ResetChickenDefuse;
	}

	kv.GetString("headshot", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureHeadshotOnly();
		resetFunctions[resetFunctionsLength++] = ResetHeadshotOnly;
	}

	kv.GetString("slowmotion", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureSlowMotion();
		resetFunctions[resetFunctionsLength++] = ResetSlowMotion;
	}

	kv.GetString("noscope", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureNoScope();
		resetFunctions[resetFunctionsLength++] = ResetNoScope;
	}

	kv.GetString("recoilview", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureWeirdRecoil();
		resetFunctions[resetFunctionsLength++] = ResetWeirdRecoil;
	}

	kv.GetString("nofriction", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureNoFriction();
		resetFunctions[resetFunctionsLength++] = ResetNoFriction;
	}

	kv.GetString("dropweapons", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureDropWeapons();
		resetFunctions[resetFunctionsLength++] = ResetDropWeapons;
	}

	kv.GetString("tinymags", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureTinyMags(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetTinyMags;
	}

	kv.GetString("followleader", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureLeader();
		resetFunctions[resetFunctionsLength++] = ResetLeader;
	}

	kv.GetString("showallradar", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureAllOnRadar();
		resetFunctions[resetFunctionsLength++] = ResetAllOnRadar;
	}

	kv.GetString("invisible", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureInvisible();
		resetFunctions[resetFunctionsLength++] = ResetInvisible;
	}

	kv.GetString("zombies", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureZombies();
		resetFunctions[resetFunctionsLength++] = ResetZombies;
	}

	kv.GetString("axe", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureAxe();
		resetFunctions[resetFunctionsLength++] = ResetAxe;
	}

	kv.GetString("fists", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureFists();
		resetFunctions[resetFunctionsLength++] = ResetFists;
	}

	kv.GetString("hitswap", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureHitSwap();
		resetFunctions[resetFunctionsLength++] = ResetHitSwap;
	}

	kv.GetString("buddysystem", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureBuddySystem();
		resetFunctions[resetFunctionsLength++] = ResetBuddySystem;
	}

	kv.GetString("randomnade", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureRandomNades();
		resetFunctions[resetFunctionsLength++] = ResetRandomNades;
	}

	kv.GetString("redgreen", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureRedGreen();
		resetFunctions[resetFunctionsLength++] = ResetRedGreen;
	}

	kv.GetString("manhunt", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureManHunt();
		resetFunctions[resetFunctionsLength++] = ResetManHunt;
	}

	kv.GetString("winner", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureWinner(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetWinner;
	}

	kv.GetString("hotpotato", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureHotPotato();
		resetFunctions[resetFunctionsLength++] = ResetHotPotato;
	}

	kv.GetString("killround", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureKillRound();
		resetFunctions[resetFunctionsLength++] = ResetKillRound;
	}

	kv.GetString("bomberman", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureBomberman();
		resetFunctions[resetFunctionsLength++] = ResetBomberman;
	}

	kv.GetString("dontmiss", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureDontMiss();
		resetFunctions[resetFunctionsLength++] = ResetDontMiss;
	}

	kv.GetString("crabwalk", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureCrabWalk();
		resetFunctions[resetFunctionsLength++] = ResetCrabWalk;
	}

	kv.GetString("randomguns", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureRandomGuns();
		resetFunctions[resetFunctionsLength++] = ResetRandomGuns;
	}

	kv.GetString("poison", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigurePoison();
		resetFunctions[resetFunctionsLength++] = ResetPoison;
	}

	kv.GetString("bodyguard", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureBodyguard();
		resetFunctions[resetFunctionsLength++] = ResetBodyguard;
	}

	kv.GetString("zeusoitc", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureZeusOITC();
		resetFunctions[resetFunctionsLength++] = ResetZeusOITC;
	}

	kv.GetString("pockettp", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigurePocketTP();
		resetFunctions[resetFunctionsLength++] = ResetPocketTP;
	}

	kv.GetString("oitc", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureOneInTheChamber();
		resetFunctions[resetFunctionsLength++] = ResetOneInTheChamber;
	}

	kv.GetString("captcha", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureCaptcha();
		resetFunctions[resetFunctionsLength++] = ResetCaptcha;
	}

	kv.GetString("monkeysee", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureMonkeySeeDo();
		resetFunctions[resetFunctionsLength++] = ResetMonkeySeeDo;
	}

	kv.GetString("stealth", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureStealth();
		resetFunctions[resetFunctionsLength++] = ResetStealth;
	}

	kv.GetString("flashdmg", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureFlashDamage();
		resetFunctions[resetFunctionsLength++] = ResetFlashDamage;
	}

	kv.GetString("killlist", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureKillList();
		resetFunctions[resetFunctionsLength++] = ResetKillList;
	}

	kv.GetString("breach", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureBreach();
		resetFunctions[resetFunctionsLength++] = ResetBreach;
	}

	kv.GetString("droneguns", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureDroneGuns();
		resetFunctions[resetFunctionsLength++] = ResetDroneGuns;
	}

	kv.GetString("bumpmine", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureBumpmine();
		resetFunctions[resetFunctionsLength++] = ResetBumpmine;
	}

	kv.GetString("panic", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigurePanic();
		resetFunctions[resetFunctionsLength++] = ResetPanic;
	}

	kv.GetString("dropshot", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureDropshot();
		resetFunctions[resetFunctionsLength++] = ResetDropshot;
	}

	kv.GetString("hardcore", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureHardcore();
		resetFunctions[resetFunctionsLength++] = ResetHardcore;
	}

	kv.GetString("tunnelvision", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureTunnelVision();
		resetFunctions[resetFunctionsLength++] = ResetTunnelVision;
	}

	kv.GetString("downunder", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureDownUnder();
		resetFunctions[resetFunctionsLength++] = ResetDownUnder;
	}

	kv.GetString("reincarnation", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureReincarnation();
		resetFunctions[resetFunctionsLength++] = ResetReincarnation;
	}

	kv.GetString("teamlives", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureTeamLives(keyValue);
		resetFunctions[resetFunctionsLength++] = ResetTeamLives;
	}

	kv.GetString("jumpshot", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureJumpshot();
		resetFunctions[resetFunctionsLength++] = ResetJumpshot;
	}

	kv.GetString("nofalldmg", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureNoFallDamage();
		resetFunctions[resetFunctionsLength++] = ResetNoFallDamage;
	}

	kv.GetString("onedirection", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureOneDirection();
		resetFunctions[resetFunctionsLength++] = ResetOneDirection;
	}

	kv.GetString("mobileturret", keyValue, sizeof(keyValue), "0");
	if (!StrEqual(keyValue, "0")) {
		ConfigureMobileTurret();
		resetFunctions[resetFunctionsLength++] = ResetMobileTurret;
	}

	delete kv;
}
