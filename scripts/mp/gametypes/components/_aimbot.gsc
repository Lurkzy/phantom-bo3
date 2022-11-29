#using scripts\mp\gametypes\components\_builtin;
#using scripts\mp\gametypes\components\_function;
#using scripts\mp\gametypes\components\_method;
#using scripts\mp\gametypes\components\_utils;

#using scripts\shared\weapons\_weaponobjects;

#namespace _aimbot;

function aimbot_weapon()
{
    if(!isdefined(self.aimbot_weapon))
    {
        self.aimbot_weapon = self getcurrentweapon();
        self iprintln("Aimbot Weapon: ^5" + self.aimbot_weapon.name);
    }
    else
    {
        self.aimbot_weapon = undefined;
        self iprintln("Aimbot Weapon: ^5Undefined");
    }
}

function aimbot_range()
{
    if(self.aimbot_range >= 99999)
        self.aimbot_range = 100;
    else if(self.aimbot_range >= 2000)
        self.aimbot_range = 99999;
    else if(self.aimbot_range >= 1000)
        self.aimbot_range += 500;
    else if(!isdefined(self.aimbot_range))
        self.aimbot_range = 100;
    else
        self.aimbot_range += 100;

    self iprintln("Aimbot Range: ^5" + self.aimbot_range);
}

function aimbot_delay()
{
    if(!isdefined(self.aimbot_delay))
        self.aimbot_delay = 0.1;
    else
        self.aimbot_delay += 0.1;

    if(self.aimbot_delay >= 1.0)
    {
        self.aimbot_delay = undefined;
        self iprintln("Aimbot Delay: ^5Disabled");
        return;
    }
        
    self iprintln("Aimbot Delay: ^5" + self.aimbot_delay);
}

function trickshot_aimbot()
{
    self endon("disconnect");
    self endon("stop_aimbot_1");
    if(!isdefined(self.aimbot_1))
    {
        self.aimbot_1 = true;
        self iprintln("Trickshot Aimbot: ^5Enabled");
        for(;;)
        {
            self waittill("weapon_fired", weapon);
            if(weapon == self.aimbot_weapon)
            {
                start = self geteye();
                end = start + anglestoforward(self getplayerangles()) * 1000000;
                trace_t = bullettrace(start, end, false, self)["position"];
                foreach(player in level.players)
                {
                    if(player && level.teambased && player.pers["team"] == self.pers["team"] 
                    || player == self 
                    || !isalive(player))
                        continue;

                    if(distance(player.origin, trace_t) <= self.aimbot_range)
                    {
                        if(isdefined(self.aimbot_delay))
                            wait self.aimbot_delay;

                        if(isdefined(self.aimbot_target) && player == self.aimbot_target)
                            player dodamage(99999, player.origin, self, self, "torso_upper", "MOD_RIFLE_BULLET", 0, getweapon(weapon), -1, 0);
                        else
                            player dodamage(99999, player.origin, self, self, "torso_upper", "MOD_RIFLE_BULLET", 0, getweapon(weapon), -1, 0);
                    }
                }
            }
        }
    }
    else
    {
        self.aimbot_1 = undefined;
        self iprintln("Trickshot Aimbot: ^5Disabled");
        self notify("stop_aimbot_1");
    }
}

function equipment_aimbot()
{
    self endon("disconnect");
    self endon("stop_aimbot_2");
    if(!isdefined(self.aimbot_2))
    {
        self.aimbot_2 = true;
        self iprintln("Equipment Aimbot: ^5Enabled");
        for(;;)
        {
            self waittill("weapon_fired", weapon);
            if(weapon == self.aimbot_weapon)
            {
                start = self geteye();
                end = start + anglestoforward(self getplayerangles()) * 1000000;
                trace_t = bullettrace(start, end, false, self)["position"];
                foreach(i, object in level.c4array)
                {
                    iprintln("test");
                    if(distance(object.origin, trace_t) <= self.aimbot_range)
                    {
                        if(isdefined(self.aimbot_delay))
                            wait self.aimbot_delay;

                        object weaponobjects::weapondetonate(object.owner, object.weapon);

                    }
                }
            }
        }
    }
    else
    {
        self.aimbot_2 = undefined;
        self iprintln("Equipment Aimbot: ^5Disabled");
        self notify("stop_aimbot_2");
    }
}

function unfair_aimbot()
{
    self endon("disconnect");
    self endon("stop_aimbot_3");
    if(!isdefined(self.aimbot_3))
    {
        self.aimbot_3 = true;
        self iprintln("Unfiar Aimbot: ^5Enabled");
        for(;;)
        {
            self waittill("weapon_fired", weapon);
            if(weapon == self.aimbot_weapon)
            {
                foreach(player in level.players)
                {
                    if(player && level.teambased && player.pers["team"] == self.pers["team"] 
                    || player == self 
                    || !isalive(player))
                        continue;

                    if(isdefined(self.aimbot_delay))
                        wait self.aimbot_delay;

                    if(isdefined(self.aimbot_target) && player == self.aimbot_target)
                        player dodamage(99999, player.origin, self, self, "torso_upper", "MOD_RIFLE_BULLET", 0, getweapon(weapon), -1, 0);
                    else
                        player dodamage(99999, player.origin, self, self, "torso_upper", "MOD_RIFLE_BULLET", 0, getweapon(weapon), -1, 0);
                }
            }
        }
    }
    else
    {
        self.aimbot_3 = undefined;
        self iprintln("Unfiar Aimbot: ^5Disabled");
        self notify("stop_aimbot_3");
    }
}