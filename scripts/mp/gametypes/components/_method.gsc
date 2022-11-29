#using scripts\mp\_util;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;
#using scripts\mp\bots\_bot;
#using scripts\shared\bots\_bot;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\killstreaks\_killstreaks;

#using scripts\mp\gametypes\components\_builtin;
#using scripts\mp\gametypes\components\_function;
#using scripts\mp\gametypes\components\_utils;
#using scripts\mp\gametypes\components\_menu;

#namespace _method;

function gode_mode()
{
    if(!isdefined(self.pers["godmode"]))
    {
		self enableinvulnerability();
        self.pers["godmode"] = true;
        self iprintln("God Mode: ^5Enabled");
    }
    else
    {
		self disableinvulnerability();
        self.pers["godmode"] = undefined;
        self iprintln("God Mode: ^5Disabled");
    }
}

function _unlimited_ammo()
{
    if(!self.pers["unlimited_ammo"])
    {
        self iprintln("Unlimited Ammo: ^5Enabled");
        self unlimited_ammo();
        self.pers["unlimited_ammo"] = true;
    }
    else
    {
        self notify("stop_unlimited_ammo");
        self iprintln("Unlimited Ammo: ^5Disabled");
        self.pers["unlimited_ammo"] = false;
    }
}

function unlimited_ammo()
{
    self endon("stop_unlimited_ammo");
    self endon("disconnect");
    while(isdefined(self) && self.pers["unlimited_ammo"])
    {
        weapon = self getcurrentweapon();
        if(weapon != level.weaponnone)
        {
            self setweaponoverheating(0, 0);
            clip = weapon.clipsize;

            self setweaponammoclip(weapon, clip);
        }
        wait .1;
    }
}

function third_person()
{
    if(!isdefined(self.pers["third_person"]))
	{
		self SetClientThirdPerson(1);
		self SetClientThirdPersonAngle(354);
		self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
		self.pers["third_person"] = true;
		self iprintln("Third Person: ^5Enabled");
	}
	else
	{
		self SetClientThirdPerson(0);
		self SetClientThirdPersonAngle(0);
		self setDepthOfField(0, 0, 512, 4000, 4, 0);
		self.pers["third_person"] = undefined;
		self iprintln("Third Person: ^5Disabled");
	}
	self resetFov();
}

function unlimited_sprint()
{
	if(!isdefined(self.pers["unlimited_sprint"]))
	{
		self.pers["unlimited_sprint"] = true;
		SetDvar("player_sprintUnlimited", 1);
		self iprintln("Unlimited Sprint: ^5Enabled");
	}
	else
	{
		self.pers["unlimited_sprint"] = undefined;
		SetDvar("player_sprintUnlimited", 0);
		self iprintln("Unlimited Sprint: ^5Disabled");
	}
}

function unlimited_boost()
{
	if(!isdefined(self.pers["unlimited_boost"]))
	{
		self iprintln("Unlimited Boost: ^5Enabled");
        self boost();
		self.pers["unlimited_boost"] = true;
	}
	else
	{
		self iprintln("Unlimited Boost: ^5Disabled");
	    self notify("stop_boost");
		self.pers["unlimited_boost"] = undefined;
	}
}

function boost()
{
	self endon("stop_boost");
	for(;;)
	{
		self setdoublejumpenergy(100);
		_builtin::waitserverframe();
	}
}

function refill_streaks()
{
	self globallogic_score::_setPlayerMomentum(self, 9000);
	self iprintln("Scorestreaks: ^5Refilled");
}

function refill_specialist()
{
	self GadgetPowerSet(0, 100);
	self iprintln("Gadget Power: ^5Refilled");
}

function console_fov()
{
    if(!isdefined(self.pers["console_fov"]))
    {
        SetDvar("cg_gun_x", 1.7);
        self iprintln("Console FOV: ^5Enabled");
        self.pers["console_fov"] = true;
    }
    else
    {
        SetDvar("cg_gun_x", 0);
        self iprintln("Console FOV: ^5Disabled");
        self.pers["console_fov"] = undefined;
    }
}

function disable_oob()
{
	if(GetDvarInt("oob_enabled", 1))
	{
		SetDvar("oob_enabled", 0);
		self iprintln("oob: ^5Disabled");
	}
	else
	{
		SetDvar("oob_enabled", 1);
		self iprintln("oob: ^5Enabled");
	}
}

function disable_spawn_text()
{
	if(GetDvarInt("menu_spawnText", 1))
	{
		SetDvar("menu_spawnText", 0);
		self iprintln("Spawn Text: ^5Disabled");
	}
	else
	{
		SetDvar("menu_spawnText", 1);
		self iprintln("Spawn Text: ^5Enabled");
	}
}

function save_player_location(print = false)
{
    self.pers["saved_position"] = self.origin;
    self.pers["saved_angles"] = self getplayerangles();

    if(print)
        self iprintln("Position ^5Saved^7");
}

function load_player_location(print = false)
{
    if(!isdefined(self.pers["saved_position"]))
        self iprintln("Please Save a position first!");

    self setorigin(self.pers["saved_position"]);
    self setplayerangles(self.pers["saved_angles"]);

    if(print)
        self iprintln("Position ^5Loaded^7");
}

function load_player_location_on_spawn()
{
    if(!isdefined(self.pers["load_position_on_spawn"]))
    {
        self.pers["load_position_on_spawn"] = true;
        self iprintln("Load Position on Spawn: ^5Enabled^7");
    }
    if(!self.pers["load_position_on_spawn"])
    {
        self.pers["load_position_on_spawn"] = true;
        self iprintln("Load Position on Spawn: ^5Enabled^7");
    }
    else 
    {
        self.pers["load_position_on_spawn"] = false;
        self iprintln("Load Position on Spawn: ^5Disabled^7");
    }
}

function save_and_load()
{
    self endon("disconnect");
    self notify("change_snl");

    if(!isdefined(self.snl))
    {
        self save_load();
        self.snl = true;
        self iprintln("Save and Load: ^5Enabled^7");
        self iprintln("^5Crouch ^7+ ^5[{+Actionslot 1}] to save position");
        self iprintln("^5Crouch ^7+ ^5[{+Actionslot 2}] to load position");
    }
    else
    {
        self.snl = undefined;
        self iprintln("Save and Load: ^5Disabled^7");
    }
}

function save_load()
{
    self endon("change_snl");
    for(;;)
    {
        if(isdefined(self.snl) && self.snl)
        {
            if(self getstance() == "crouch" && self actionslotonebuttonpressed())
            {
                self save_player_location(true);

                wait .1;
            }

            if(self getstance() == "crouch" && self actionslottwobuttonpressed())
            {
                self load_player_location(false);

                wait .1;
            }
        }

        wait .1;
    }
}

function spec_nade()
{
	if(!isdefined(self.pers["spec_nade"]))
	{
		self iprintln("Spec Nade: ^5Enabled");
        self monitor_nade();
		self.pers["spec_nade"] = true;
	}
	else
	{
		self iprintln("Spec Nade: ^5Disabled");
	    self notify("stop_spec_nade");
		self.pers["spec_nade"] = undefined;
	}
}

function monitor_nade()
{
    self endon("stop_spec_nade");
    for(;;)
    {
        self waittill("grenade_fire", grenade, grenade_name);
        self playerlinkto(grenade);
        grenade waittill("death");
        self unlink();

        wait .1;
    }
}

function change_camo(camoIndex)
{
	weapon = self GetCurrentWeapon();
	weapon_options = self CalcWeaponOptions(camoIndex, 0, 0);
	acvi = self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, 0);
	self TakeWeapon(weapon, 1);
	self GiveWeapon(weapon, weapon_options, acvi);
	self SwitchToWeapon(weapon);
	self iprintln("Weapon camo index: ^5" + camoIndex);
}

function give_attachment(attachment)
{
    new_attachment = [];
    new_attachment[0] = attachment;
    
    weapon = self getcurrentweapon();
    att = strtok(weapon.name, "+");
    foreach(i, a in att)
    {
        if(a != attachment)
            new_attachment[new_attachment.size] = a;
    }

	new_weapon = GetWeapon(weapon.rootweapon.name, new_attachment);
    renderOptions = self getweaponoptions(weapon);
	acvi = self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, 2);

    self TakeWeapon(weapon);
	self GiveWeapon(new_weapon, renderOptions, acvi);
	self SwitchToWeapon(new_weapon);
	self GiveStartAmmo(new_weapon);
	self iprintln("Weapon Given: ^5" + new_weapon.name);
}


function g(weapon)
{
	weapon = GetWeapon(weapon);
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	self GiveStartAmmo(weapon);
	self iprintln("Weapon Given: ^5" + weapon);
}

function t(weapon)
{
	weapon = self getcurrentweapon();
	self TakeWeapon(weapon);
	self iprintln("Weapon Taken: ^5" + weapon);
}

function d(weapon)
{
	weapon = self getcurrentweapon();
	self DropItem(weapon);
	self iprintln("Weapon Dropped: ^5" + weapon);
}

function refill_ammo(weapon)
{
	weapon = self getcurrentweapon();
	self GiveMaxAmmo(weapon);
	self iprintln("Weapon Refilled: ^5" + weapon);
}

function refill_all_weapons()
{
    weaponslist = self getweaponslist(1);
    foreach(weapon in weaponslist)
	    self givemaxammo(weapon);

    
	self iprintln("Weapons: ^5Refilled");
}

function s(hero_weapon)
{
	previousGadget = undefined;
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			if(!isdefined(previousGadget))
			{
				previousGadget = self._gadgets_player[i];
			}
			self TakeWeapon(self._gadgets_player[i]);
		}
	}
	selectedWeapon = hero_weapon;
	self GiveWeapon(GetWeapon(selectedWeapon));
	self GadgetPowerSet(0, 100);
}

function give_killstreak(killstreak)
{
	self thread killstreaks::give(killstreak);
}

function reset_specialist_greed()
{
    self.gadget_weapon = undefined;
    self notify("stop_greed");
    self iprintln("Specialist Greed: ^5Reset");
}

function specialists_greed(weapon)
{
	if(!isdefined(self.gadget_weapon))
	{
		self.gadget_weapon = weapon;
		self thread s("gadget_flashback");
		self thread greed();
		self iprintln("Specialist Greed set to: ^5" + weapon);
	}
	else
	{
		self iprintln("^5Error: ^7Specialist Greed already defined");
	}
}

function greed()
{
	self endon("stop_greed");
	for(;;)
	{
		greed = GetWeapon(self.gadget_weapon);
		self waittill("flashback");
		if(self.gadget_weapon == "gadget_flashback")
		{
			wait(0.2);
			self thread s("gadget_flashback");
			self waittill("flashback");
			self.gadget_weapon = undefined;
			self notify("stop_greed");
		}
		else if(greed.isgadget)
		{
			wait(0.2);
			self thread s(self.gadget_weapon);
		}
		else
		{
			self thread s(self.gadget_weapon);
		}
		wait(0.1);
	}
}

function glitch_to_change_class()
{
    self notify("update_change_class");

    if(self.pers["glitch_change_class"] >= 9)
    {
        self.pers["glitch_change_class"] = -1;
        self iprintln("Glitch to change class: ^5Disabled");
    }
    else
    {
        self.pers["glitch_change_class"]++;
        self iprintln("Glitch to change class: ^5class" + self.pers["glitch_change_class"]);
        self change_class_glitch(self.pers["glitch_change_class"]);
    }
}

function change_class_glitch( class_num )
{	
    self endon("update_change_class");
	for(;;)
	{
		self waittill("flashback");
		wait .15;
		self notify("menuresponse", game["menu_changeclass"], "custom" + class_num);
		
        wait .1;
	}
}

function glitch_to_saved_position()
{
    self endon("stop_gtsl");
    if(!isdefined(self.pers["glitch_to_position"]))
    {
        self.pers["glitch_to_position"] = true;
        self iprintln("Glitch to load position: ^5Enabled");
        for(;;)
        {
            self waittill("flashback");
            wait .3;
            if(isdefined(self.pers["saved_position"]))
            {
                self setorigin(self.pers["saved_position"]);
                self setplayerangles(self.pers["saved_angles"]);
            }
            wait .05;    
        }
    }
    else
    {
        self.pers["glitch_to_position"] = undefined;
        self iprintln("Glitch to load position: ^5disabled");
        self notify("stop_gtsl");
    }
}

function glitch_to_canswap()
{
    self endon("stop_gtc");
    if(!isdefined(self.pers["glitch_to_canswap"]))
    {
        self.pers["glitch_to_canswap"] = self getcurrentweapon();
        self iprintln("Glitch to canswap: ^5Enabled");
        self iprintln("Glitch to canswap: ^5" + self.pers["glitch_to_canswap"].name);
        for(;;)
        {
            self waittill("flashback");
            weapon_array = self getweaponslist();
            foreach(weapon in weapon_array)
                self takeweapon(weapon);
                
            wait .05;
            foreach(weapon in weapon_array)
                self giveweapon(weapon);

            self initialweaponraise(self.pers["glitch_to_canswap"]);
            self switchtoweapon(self.pers["glitch_to_canswap"]);
            wait .05;    
        }
    }
    else
    {
        self.pers["glitch_to_canswap"] = undefined;
        self iprintln("Glitch to canswap: ^5disabled");
        self notify("stop_gtc");
    }
}

function glitch_to_no_ammo()
{
    self endon("stop_gtna");
    if(!isdefined(self.pers["glitch_to_noclip"]))
    {
        self.pers["glitch_to_noclip"] = self getcurrentweapon();
        self iprintln("Glitch to Empty Clip: ^5Enabled");
        self iprintln("Glitch to Empty Clip: ^5" + self.pers["glitch_to_noclip"].name);
        for(;;)
        {
            self waittill("flashback");
            wait .15;
            self setWeaponAmmoClip(self.pers["glitch_to_noclip"], 0);
            wait .05;    
        }
    }
    else
    {
        self.pers["glitch_to_noclip"] = undefined;
        self iprintln("Glitch to Empty Clip: ^5Disabled");
        self notify("stop_gtna");
    }
}

function glitch_to_closest_position()
{
    self endon("stop_gtce");
    if(!isdefined(self.pers["glitch_to_enemy_position"]))
    {
        self.pers["glitch_to_enemy_position"] = ArraySortClosest(level.players, self.origin);
        self iprintln("Glitch to closest enemy: ^5Enabled");
        for(;;)
        {
            self waittill("flashback");
            wait .3;
            self setorigin(self.pers["glitch_to_enemy_position"].origin + (30, 0, 0));

            wait .05;    
        }
    }
    else
    {
        self.pers["glitch_to_enemy_position"] = undefined;
        self iprintln("Glitch to closest enemy: ^5Disabled");
        self notify("stop_gtce");
    }
}

function change_status( player, status )
{
    if(status == "verified")
        player _menu::init();

    player.status = status;
    player suicide();
    wait .5;
    player thread [[level.spawnclient]]();
}

function change_player_state( player, frozen )
{
    if(frozen)
    {
        self iprintln("Player Controls: ^5Frozen");
        player freezecontrols(true);
    }
    else
    {
        self iprintln("Player Controls: ^5Unfrozen");
        player freezecontrols(false);
    }
}

function save_player_position( player )
{
    player.pers["saved_position"] = player.origin;
    player.pers["saved_angles"] = player getplayerangles();
    self iprintln("Player Position ^5Saved^7");
}

function load_player_position( player )
{
    if(!isdefined(player.pers["saved_position"]))
        player iprintln("Please Save a position first!");

    player setorigin(player.pers["saved_position"]);
    player setplayerangles(player.pers["saved_angles"]);
    self iprintln("Player Position ^5Loaded^7");
}

function load_player_position_on_spawn( player )
{
    if(!isdefined(player.pers["load_position_on_spawn"]))
    {
        player.pers["load_position_on_spawn"] = true;
        self iprintln("Load Player Position on Spawn: ^5Enabled^7");
    }
    else 
    {
        player.pers["load_position_on_spawn"] = undefined;
        self iprintln("Load Player Position on Spawn: ^5Disabled^7");
    }
}

function lock_player_location( player )
{
    if(!isdefined(player.lock))
    {
        player.lock = spawn("script_model", player.origin);
        player playerLinkTo(player.lock);
        self iprintln("Player Position: ^5Locked");
    }
    else
    {
        player unlink();
        player.lock = undefined;
        self iprintln("Player Position: ^5Unlocked");
    }
}

function teleport_to_me( player )
{
    player setorigin(self.origin);
    self iprintln("Player ^5Teleported");
}

function teleport_to_crosshair( player )
{
    start = self geteye();
    end = start + anglestoforward(self getplayerangles()) * 1000000;
    trace_t = bullettrace(start, end, false, self)["position"];

    player setorigin(trace_t);
    self iprintln("Player ^5Teleported");
}

function aimbot_target_player( player )
{
    if(!isdefined(self.aimbot_target))
    {
        self.aimbot_target = player;
        self iprintln("Aimbot Target: ^5" + player.name);
    }
    else
    {
        self.aimbot_target = undefined;
        self iprintln("Aimbot Target: ^5Undefined");
    }
}

function bot_use_active_camo( bot )
{
    bot s("gadget_camo");
    wait .3;
    bot bot::activate_hero_gadget("gadget_camo");
}

function bot_use_heat_wave( bot )
{
    bot s("gadget_heat_wave");
    wait .3;
    bot bot::activate_hero_gadget("gadget_heat_wave");
}

function freeze_all_bots()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(player util::is_bot())
		{
			player FreezeControls(1);
		}
	}
	iprintln("Bot State: ^5Frozen");
}

function unfreeze_all_bots()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(player util::is_bot())
		{
			player FreezeControls(0);
		}
	}
	iprintln("Bot State: ^5Unfrozen");
}

function teleport_all_bots_to_me()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(player util::is_bot())
		{
            player setorigin(self.origin);
		}
	}
    self iprintln("Player ^5Teleported");
}

function teleport_all_bots_to_crosshair()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(player util::is_bot())
		{
            start = self geteye();
            end = start + anglestoforward(self getplayerangles()) * 1000000;
            trace_t = bullettrace(start, end, false, self)["position"];

            player setorigin(trace_t);
		}
	}
    self iprintln("Player ^5Teleported");
}

function test_1()
{
    self.old_weapon = self getcurrentweapon();
    self.test_1 = self getweaponslist();
    foreach(weapon in self.test_1)
        self takeweapon(weapon);
        
    foreach(weapon in self.test_1)
    {
        new_weapon = GetWeapon(weapon.rootweapon.name);
        renderOptions = self getweaponoptions(weapon);
        acvi = self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, 2);
        self giveweapon(new_weapon, renderOptions, acvi);
    }

    //self setWeaponAmmoClip(self.old_weapon, 0);

    wait .1;
    self setspawnweapon(self.old_weapon);
}