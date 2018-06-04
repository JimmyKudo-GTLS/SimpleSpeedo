/*======================[Simple Speedo by GTLS]=====================================*/

#include <a_samp>
#include <zcmd>

//Forwards
forward ShowPlayerSpeedo(playerid);
forward HidePlayerSpeedo(playerid);
forward SpeedoUpdate(playerid);

//TextDraw
new PlayerText:SpeedoTextDraws[7];

new SpeedoTimer[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("\nSpeed-o-Meter Loaded.");
	return 1;
}

public OnFilterScriptExit()
{
	printf("\nSpeed-o-Meter Unloaded.");
	return 1;
}
new VehicleNames[212][] = {
   "Landstalker",  "Bravura",  "Buffalo", "Linerunner", "Perennial", "Sentinel",
   "Dumper",  "Firetruck" ,  "Trashmaster" ,  "Stretch",  "Manana",  "Infernus",
   "Voodoo", "Pony",  "Mule", "Cheetah", "Ambulance",  "Leviathan",  "Moonbeam",
   "Esperanto", "Taxi",  "Washington",  "Bobcat",  "Mr Whoopee", "BF Injection",
   "Hunter", "Premier",  "Enforcer",  "Securicar", "Banshee", "Predator", "Bus",
   "Rhino",  "Barracks",  "Hotknife",  "Trailer",  "Previon", "Coach", "Cabbie",
   "Stallion", "Rumpo", "RC Bandit",  "Romero", "Packer", "Monster",  "Admiral",
   "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer",  "Turismo", "Speeder",
   "Reefer", "Tropic", "Flatbed","Yankee", "Caddy", "Solair","Berkley's RC Van",
   "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron","RC Raider","Glendale",
   "Oceanic", "Sanchez", "Sparrow",  "Patriot", "Quad",  "Coastguard", "Dinghy",
   "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",  "Regina",  "Comet", "BMX",
   "Burrito", "Camper", "Marquis", "Baggage", "Dozer","Maverick","News Chopper",
   "Rancher", "FBI Rancher", "Virgo", "Greenwood","Jetmax","Hotring","Sandking",
   "Blista Compact", "Police Maverick", "Boxville", "Benson","Mesa","RC Goblin",
   "Hotring Racer", "Hotring Racer", "Bloodring Banger", "Rancher",  "Super GT",
   "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt",
   "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal",  "Hydra",
   "FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona",
   "FBI Truck", "Willard", "Forklift","Tractor","Combine","Feltzer","Remington",
   "Slamvan", "Blade", "Freight", "Streak","Vortex","Vincent","Bullet","Clover",
   "Sadler",  "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob",  "Tampa",
   "Sunrise", "Merit",  "Utility Truck",  "Nevada", "Yosemite", "Windsor",  "Monster",
   "Monster","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RCTiger",
   "Flash","Tahoma","Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower",
   "Dune", "Sweeper", "Broadway", "Tornado", "AT-400",  "DFT-30", "Huntley",
   "Stafford", "BF-400", "Newsvan","Tug","Trailer","Emperor","Wayfarer","Euros",
   "Hotdog", "Club", "Trailer", "Trailer","Andromada","Dodo","RC Cam", "Launch",
   "Police Car (LSPD)", "Police Car (SFPD)","Police Car (LVPD)","Police Ranger",
   "Picador",   "S.W.A.T. Van",  "Alpha",   "Phoenix",   "Glendale",   "Sadler",
   "Luggage Trailer","Luggage Trailer","Stair Trailer", "Boxville", "Farm Plow",
   "Utility Trailer"
};

stock GetVehicleName(vehicleid) //Thanks to Tee
{
	new String[25];
	printf("Vehicle MODEL: %d",GetVehicleModel(vehicleid));
	format(String,sizeof(String),"%s",VehicleNames[GetVehicleModel(vehicleid) - 400]);
	return String;
}

LoadSpeedoTextDraws(playerid) //Loading TextDraws
{
    SpeedoTextDraws[0] = CreatePlayerTextDraw(playerid, 541.250000, 358.583343, "box");
	PlayerTextDrawLetterSize(playerid, SpeedoTextDraws[0], 0.000000, 1.562500);
	PlayerTextDrawTextSize(playerid, SpeedoTextDraws[0], 540.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, SpeedoTextDraws[0], 1);
	PlayerTextDrawColor(playerid, SpeedoTextDraws[0], -1);
	PlayerTextDrawUseBox(playerid, SpeedoTextDraws[0], 1);
	PlayerTextDrawBoxColor(playerid, SpeedoTextDraws[0], 8388863);
	PlayerTextDrawSetShadow(playerid, SpeedoTextDraws[0], 0);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTextDraws[0], 255);
	PlayerTextDrawFont(playerid, SpeedoTextDraws[0], 1);
	PlayerTextDrawSetProportional(playerid, SpeedoTextDraws[0], 1);

	SpeedoTextDraws[1] = CreatePlayerTextDraw(playerid, 545.000000, 375.499969, "box");
	PlayerTextDrawLetterSize(playerid, SpeedoTextDraws[1], 0.000000, -0.250000);
	PlayerTextDrawTextSize(playerid, SpeedoTextDraws[1], 630.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, SpeedoTextDraws[1], 1);
	PlayerTextDrawColor(playerid, SpeedoTextDraws[1], -1);
	PlayerTextDrawUseBox(playerid, SpeedoTextDraws[1], 1);
	PlayerTextDrawBoxColor(playerid, SpeedoTextDraws[1], 8388863);
	PlayerTextDrawSetShadow(playerid, SpeedoTextDraws[1], 0);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTextDraws[1], 255);
	PlayerTextDrawFont(playerid, SpeedoTextDraws[1], 1);
	PlayerTextDrawSetProportional(playerid, SpeedoTextDraws[1], 1);

	SpeedoTextDraws[2] = CreatePlayerTextDraw(playerid, 540.000000, 378.416687, "box");
	PlayerTextDrawLetterSize(playerid, SpeedoTextDraws[2], 0.000000, 3.875000);
	PlayerTextDrawTextSize(playerid, SpeedoTextDraws[2], 632.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, SpeedoTextDraws[2], 1);
	PlayerTextDrawColor(playerid, SpeedoTextDraws[2], -1);
	PlayerTextDrawUseBox(playerid, SpeedoTextDraws[2], 1);
	PlayerTextDrawBoxColor(playerid, SpeedoTextDraws[2], -252645251);
	PlayerTextDrawSetShadow(playerid, SpeedoTextDraws[2], 0);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTextDraws[2], 255);
	PlayerTextDrawFont(playerid, SpeedoTextDraws[2], 1);
	PlayerTextDrawSetProportional(playerid, SpeedoTextDraws[2], 1);

	SpeedoTextDraws[3] = CreatePlayerTextDraw(playerid, 538.750000, 376.083343, "");
	PlayerTextDrawTextSize(playerid, SpeedoTextDraws[3], 43.000000, 36.000000);
	PlayerTextDrawAlignment(playerid, SpeedoTextDraws[3], 1);
	PlayerTextDrawColor(playerid, SpeedoTextDraws[3], -1);
	PlayerTextDrawSetShadow(playerid, SpeedoTextDraws[3], 0);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTextDraws[3], -252645246);
	PlayerTextDrawFont(playerid, SpeedoTextDraws[3], 5);
	PlayerTextDrawSetProportional(playerid, SpeedoTextDraws[3], 0);
	PlayerTextDrawSetPreviewModel(playerid, SpeedoTextDraws[3], 411);
	PlayerTextDrawSetPreviewRot(playerid, SpeedoTextDraws[3], 0.000000, 0.000000, 60.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, SpeedoTextDraws[3], 3, 1);

	SpeedoTextDraws[4] = CreatePlayerTextDraw(playerid, 591.250000, 376.666625, "Infernus");
	PlayerTextDrawLetterSize(playerid, SpeedoTextDraws[4], 0.234374, 1.074999);
	PlayerTextDrawTextSize(playerid, SpeedoTextDraws[4], -44.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, SpeedoTextDraws[4], 1);
	PlayerTextDrawColor(playerid, SpeedoTextDraws[4], -16776961);
	PlayerTextDrawSetShadow(playerid, SpeedoTextDraws[4], 0);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTextDraws[4], 255);
	PlayerTextDrawFont(playerid, SpeedoTextDraws[4], 1);
	PlayerTextDrawSetProportional(playerid, SpeedoTextDraws[4], 1);

	SpeedoTextDraws[5] = CreatePlayerTextDraw(playerid, 603.125000, 393.583435, "65");
	PlayerTextDrawLetterSize(playerid, SpeedoTextDraws[5], 0.258749, 1.104165);
	PlayerTextDrawAlignment(playerid, SpeedoTextDraws[5], 1);
	PlayerTextDrawColor(playerid, SpeedoTextDraws[5], 41215);
	PlayerTextDrawSetShadow(playerid, SpeedoTextDraws[5], 0);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTextDraws[5], 255);
	PlayerTextDrawFont(playerid, SpeedoTextDraws[5], 1);
	PlayerTextDrawSetProportional(playerid, SpeedoTextDraws[5], 1);

	SpeedoTextDraws[6] = CreatePlayerTextDraw(playerid, 560.000000, 358.583343, "0 Mph");
	PlayerTextDrawLetterSize(playerid, SpeedoTextDraws[6], 0.379375, 1.401666);
	PlayerTextDrawTextSize(playerid, SpeedoTextDraws[6], 655.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, SpeedoTextDraws[6], 1);
	PlayerTextDrawColor(playerid, SpeedoTextDraws[6], -65281);
	PlayerTextDrawSetShadow(playerid, SpeedoTextDraws[6], 0);
	PlayerTextDrawBackgroundColor(playerid, SpeedoTextDraws[6], 255);
	PlayerTextDrawFont(playerid, SpeedoTextDraws[6], 2);
	PlayerTextDrawSetProportional(playerid, SpeedoTextDraws[6], 1);

}
public OnPlayerConnect(playerid)
{
	SetPVarInt(playerid, "SpeedoON", 1);
	SendClientMessage(playerid, 0xFF00AAFF,"Speedo Enabled. You can use /togspeedo to disable/re-enable it.");
	LoadSpeedoTextDraws(playerid);
	return 1;
}

public ShowPlayerSpeedo(playerid)
{
	new vehname[16],vehid = GetPlayerVehicleID(playerid), idstr[4], vehmodel = GetVehicleModel(vehid);
	
    SpeedoTimer[playerid] = SetTimerEx("SpeedoUpdate",1000,1,"i",playerid); //Timer for Updating Speed.

	
    PlayerTextDrawSetPreviewModel(playerid, SpeedoTextDraws[3], vehmodel); //Setting the PreviewModel
    format(vehname, sizeof(vehname), "%s", GetVehicleName(vehid));
    format(idstr, sizeof(idstr), "%d", vehid);
    printf("%s", vehname);
    PlayerTextDrawSetString(playerid, SpeedoTextDraws[4], vehname); //Setting Vehicle Name
    PlayerTextDrawSetString(playerid, SpeedoTextDraws[5], idstr); //Setting Vehicle ID

	PlayerTextDrawShow(playerid, SpeedoTextDraws[0]);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[1]);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[2]);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[3]);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[4]);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[5]);
    PlayerTextDrawShow(playerid, SpeedoTextDraws[6]);
	return 1;
}

public HidePlayerSpeedo(playerid)
{
	KillTimer(SpeedoTimer[playerid]); //Killing of Timer
	
	PlayerTextDrawHide(playerid, SpeedoTextDraws[0]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[1]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[2]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[3]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[4]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[5]);
    PlayerTextDrawHide(playerid, SpeedoTextDraws[6]);
	return 1;
}


stock GetVehicleSpeed(vehicleid) //Credits someone on SAMP Forums forgot the name
{
	new Float:x, Float:y, Float:z, vel;

	GetVehicleVelocity(vehicleid, x, y, z);

	//vel = floatround( floatsqroot( x*x + y*y + z*z ) * 180 );			// KM/H
	vel = floatround( floatsqroot( x*x + y*y + z*z ) * 180 / 1.60934); // MPH (Comment this line if you want speed in KM

	return vel;
}

public SpeedoUpdate(playerid)
{
	new pSpeed[8], vehid = GetPlayerVehicleID(playerid);
	format(pSpeed, sizeof(pSpeed), "%i MPH",GetVehicleSpeed(vehid)); //Mph
//	format(pSpeed, sizeof(pSpeed), "%i KMpH",GetVehicleSpeed(vehid)); //KmpH
	PlayerTextDrawSetString(playerid, SpeedoTextDraws[6], pSpeed);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(SpeedoTimer[playerid]); //Just a Precaution, not needed.
	return 1;
}

CMD:Speedoon(playerid, params[])
{
	if(GetPVarInt(playerid, "SpeedoON") == 0)
	{
	    SendClientMessage(playerid, -1, "You have enabled the Speedo.");
	    SetPVarInt(playerid, "SpeedoON", 1);
     	if(IsPlayerInAnyVehicle(playerid)) ShowPlayerSpeedo(playerid);
	 }
	 else
	 {
		SendClientMessage(playerid, -1, "You have disabled the Speedo.");
		SetPVarInt(playerid, "SpeedoON", 0);
		HidePlayerSpeedo(playerid);
	 }

	return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(GetPVarInt(playerid, "SpeedoON") == 0) SendClientMessage(playerid, -1, "You have disabled Speedo. Use /togspeedo to tog back in.");
    if(GetPVarInt(playerid, "SpeedoON") == 1)
		ShowPlayerSpeedo(playerid);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		if(GetPVarInt(playerid, "SpeedoON") == 1)
				ShowPlayerSpeedo(playerid);
	}

	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT)
	{
		HidePlayerSpeedo(playerid);
	}
	return 1;
}
