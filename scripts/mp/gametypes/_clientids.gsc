#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\mp\_util;
#using scripts\mp\gametypes\sd;
#using scripts\mp\gametypes\components\_utils;
#using scripts\mp\gametypes\components\_builtin;
#using scripts\mp\gametypes\components\_method;
#using scripts\mp\gametypes\components\_function;
#using scripts\mp\gametypes\components\_menu;

#using scripts\shared\weapons\_weaponobjects;

function autoexec __init__sytem__()
{
	system::register("phantom", &__init__, undefined, undefined);
}

function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
}

function init()
{
	level.clientid = 0;
    level.prematchperiod = 0;
    level.spawned_carepackage = 0;

    setdvar("sv_cheats", 1);
}

function on_player_connect()
{
	self.clientid = matchrecordnewplayer(self);
	if(!isdefined(self.clientid) || self.clientid == -1)
	{
		self.clientid = level.clientid;
		level.clientid++;
	}

    if(self ishost())
    {
        self thread _menu::init();
        self.status = "host";
    }
    else if(self istestclient())
        self.status = "bot";
    else
        self.status = "user";
}

function on_player_spawned()
{
    self add_equipment();

    if(isdefined(self.pers["console_fov"]) && self.pers["console_fov"])
        SetDvar("cg_gun_x", 1.7);

    if(getdvarint("menu_spawn_text", 1))
    {
        self iprintln("Welcome to ^5Phantom ^7by Lurkzy");
        self iprintln("Press ^5Crouch ^7+ ^5[{+speed_throw}] ^7+ ^5[{+actionslot 1}] ^7to open the menu");
        wait 2;
        self iprintln("Enjoy ^5Bitches^7");
    }

    if(isdefined(self.pers["load_position_on_spawn"]))
    {
        if(isdefined(self.pers["saved_position"]))
            _method::load_player_location(false);
    }
}

function add_equipment()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("grenade_fire", grenade, weapon);
        if(grenade.weapon.rootweapon.name == "satchel_charge")
            level.c4array[level.c4array.size] = grenade;

        _builtin::waitserverframe();
    }
}